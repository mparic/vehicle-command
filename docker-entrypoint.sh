#!/bin/sh
set -e

# Decode TLS certs and Tesla private key from Railway env vars.
# tr -d strips whitespace that causes "base64: invalid input" errors.
mkdir -p /etc/ssl/vcp

printf '%s' "$TLS_SERVER_CERT"       | tr -d ' \t\n\r' | base64 -d \
  > /etc/ssl/vcp/server.crt

printf '%s' "$TLS_SERVER_KEY"        | tr -d ' \t\n\r' | base64 -d \
  > /etc/ssl/vcp/server.key

printf '%s' "$TESLA_PRIVATE_KEY_B64" | tr -d ' \t\n\r' | base64 -d \
  > /etc/ssl/vcp/fleet-key.pem

exec /tesla-http-proxy \
  -tls-key  /etc/ssl/vcp/server.key \
  -cert     /etc/ssl/vcp/server.crt \
  -key-file /etc/ssl/vcp/fleet-key.pem \
  -host     0.0.0.0 \
  -port     4443