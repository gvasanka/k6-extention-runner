# k6-extention-runner

K6 Docker extension runner for use with the K6 operator.

This repository builds a custom `k6` binary with additional xk6 extensions and packages it in a Docker image.

## Build

### 1. Log in to your Docker registry

```bash
docker login
```

### 2. Build the image locally

Single-architecture build:

```bash
docker build -t <registry>/<namespace>/k6-extension-runner:latest .
```

If you want a multi-platform image, use Docker Buildx:

```bash
docker buildx create --use --name k6-builder || true
docker buildx build --platform linux/amd64,linux/arm64 -t <registry>/<namespace>/k6-extension-runner:latest --push .
```

> Note: `--push` is required for Buildx multi-platform builds. If you only want to build locally with Buildx, remove `--push` and add `--load`.

## Push

If you built the image locally without pushing, tag and push it to your registry:

```bash
docker tag <registry>/<namespace>/k6-extension-runner:latest <registry>/<namespace>/k6-extension-runner:latest
docker push <registry>/<namespace>/k6-extension-runner:latest
```

## Example

```bash
REGISTRY=docker.io
NAMESPACE=your-username
IMAGE_NAME=k6-extension-runner
TAG=latest

docker build -t "$REGISTRY/$NAMESPACE/$IMAGE_NAME:$TAG" .
docker push "$REGISTRY/$NAMESPACE/$IMAGE_NAME:$TAG"
```

## Notes

- The Dockerfile uses `grafana/xk6` to build a custom `k6` binary with SQL, Kafka, and InfluxDB output extensions.
- The final image is based on `grafana/k6:1.7.1` and replaces the default `k6` binary with the custom build.
- Make sure Docker BuildKit is enabled if using Buildx for cross-platform builds.

