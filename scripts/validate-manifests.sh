#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
chart="$root/kubernetes/helm/devsecops-platform"
helm lint "$chart" -f "$chart/values-dev.yaml"
rendered="$(mktemp)"
trap 'rm -f "$rendered"' EXIT
helm template platform-demo "$chart" -f "$chart/values-dev.yaml" > "$rendered"
if command -v kubeconform >/dev/null 2>&1; then
  kubeconform -strict -summary "$rendered"
else
  echo "kubeconform not installed; Helm lint and template rendering passed (schema validation skipped)." >&2
fi
