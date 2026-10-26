#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
trivy fs --scanners vuln,misconfig,secret --severity HIGH,CRITICAL --exit-code 1 "$root"
if [[ -n "${IMAGE_REF:-}" ]]; then
  trivy image --severity HIGH,CRITICAL --exit-code 1 "$IMAGE_REF"
else
  echo "Set IMAGE_REF to scan a built container image; filesystem scan completed."
fi
