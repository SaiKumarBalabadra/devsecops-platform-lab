#!/usr/bin/env bash
set -euo pipefail

namespace="${1:-platform-demo}"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
helm upgrade --install platform-demo "$repo_root/kubernetes/helm/devsecops-platform" \
  --namespace "$namespace" --create-namespace \
  -f "$repo_root/kubernetes/helm/devsecops-platform/values-dev.yaml" \
  --set image.repository=platform-demo \
  --set image.tag=local \
  --wait --timeout 5m
