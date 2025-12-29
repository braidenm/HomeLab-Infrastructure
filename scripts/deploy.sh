#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "==> Deploy web (caddy)"
cd "$ROOT/stacks/web"

docker compose -f compose.yml pull
docker compose -f compose.yml up -d

if docker compose ps | grep -q "caddy"; then
    echo "==> Reloading Caddy configuration"
    docker compose exec -T caddy caddy reload --config /etc/caddy/Caddyfile
fi

echo "==> Status"
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
