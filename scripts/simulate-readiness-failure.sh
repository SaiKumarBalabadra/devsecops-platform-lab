#!/usr/bin/env bash
set -euo pipefail
docker compose build app
container="platform-demo-readiness-simulation-$$"
docker run --detach --rm --name "$container" \
  --publish 127.0.0.1:18001:8000 \
  --env SIMULATE_DEPENDENCY_FAILURE=true \
  platform-demo:local
cleanup() { docker stop "$container" >/dev/null 2>&1 || true; }
trap cleanup EXIT
for _ in $(seq 1 30); do
  if curl --silent --output /dev/null http://127.0.0.1:18001/health; then
    break
  fi
  sleep 1
done
status="$(curl --silent --output /dev/null --write-out '%{http_code}' http://127.0.0.1:18001/ready)"
if [[ "$status" != "503" ]]; then
  echo "Expected readiness probe to return 503; got $status" >&2
  exit 1
fi
echo "Readiness failure simulation passed (HTTP 503)."
