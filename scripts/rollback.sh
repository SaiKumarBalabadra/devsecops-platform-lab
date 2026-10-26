#!/usr/bin/env bash
set -euo pipefail

release="${1:-platform-demo}"
namespace="${2:-platform-demo-dev}"
revision="${3:-}"
if [[ -z "$revision" ]]; then
  echo "usage: $0 RELEASE NAMESPACE REVISION" >&2
  exit 2
fi
helm rollback "$release" "$revision" --namespace "$namespace" --wait --timeout 5m
