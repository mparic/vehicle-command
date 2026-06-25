# Build stage — we control this so we know exactly where the binary goes
FROM golang:1.22 AS build
WORKDIR /src
COPY . .
RUN go install ./cmd/tesla-http-proxy

# Final stage
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /
COPY --from=build /go/bin/tesla-http-proxy /tesla-http-proxy
COPY docker-entrypoint.sh /docker-entrypoint.sh
CMD ["/bin/sh", "/docker-entrypoint.sh"]