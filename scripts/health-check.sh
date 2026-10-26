#!/usr/bin/env bash
set -euo pipefail
base_url="${1:-http://127.0.0.1:8000}"
for endpoint in /health /ready /api/v1/info; do
  printf '%-14s ' "$endpoint"
  curl --fail --silent --show-error --max-time 3 "$base_url$endpoint"
  printf '\n'
done
