FROM golang:1.23.0 AS build

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN mkdir build
RUN go build -o ./build ./...

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /
COPY --from=build /go/bin/tesla-http-proxy /tesla-http-proxy
COPY docker-entrypoint.sh /docker-entrypoint.sh
CMD ["/bin/sh", "/docker-entrypoint.sh"]
