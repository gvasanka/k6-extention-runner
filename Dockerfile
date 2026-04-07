# Stage 1: Build the custom k6 binary
# Using the latest xk6 builder as of March/April 2026
FROM --platform=$BUILDPLATFORM grafana/xk6:1.3.7 AS builder

# Arguments for cross-compilation (Buildx sets these automatically)
ARG TARGETOS
ARG TARGETARCH

# Build k6 v1.7.1 with the requested extensions
# xk6 build [version] --with [extension@version]
RUN GOOS=$TARGETOS GOARCH=$TARGETARCH xk6 build v1.7.1 \
    --with github.com/grafana/xk6-sql@latest \
    --with github.com/mostafa/xk6-kafka@latest \
    --with github.com/grafana/xk6-output-influxdb@latest \
    --output /tmp/k6

# Stage 2: Final Image for AWS Linux / k6 Operator
FROM grafana/k6:1.7.1
COPY --from=builder /tmp/k6 /usr/bin/k6

# Required for k6-operator and standard execution
ENTRYPOINT ["k6"]
