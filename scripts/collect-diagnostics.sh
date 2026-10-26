#!/usr/bin/env bash
set -euo pipefail
namespace="${1:-platform-demo-dev}"
destination="${2:-./diagnostics-$(date -u +%Y%m%dT%H%M%SZ)}"
umask 077
if [[ -e "$destination" ]]; then
  echo "Refusing to overwrite existing diagnostics path: $destination" >&2
  exit 1
fi
mkdir "$destination"
kubectl version > "$destination/kubectl-version.txt" 2>&1
kubectl -n "$namespace" get deployments,pods,services,endpoints -o wide > "$destination/workloads.txt" 2>&1
kubectl -n "$namespace" get events --sort-by=.lastTimestamp > "$destination/events.txt" 2>&1
kubectl -n "$namespace" logs deployment/platform-demo-devsecops-platform \
  --all-containers=true --since=1h --tail=500 > "$destination/application.log" 2>&1
echo "Diagnostics collected at $destination. No Secret objects were queried. Inspect and redact logs before sharing."
