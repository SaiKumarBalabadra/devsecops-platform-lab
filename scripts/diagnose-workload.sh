#!/usr/bin/env bash
set -euo pipefail
namespace="${1:-platform-demo-dev}"
deployment="${2:-platform-demo-devsecops-platform}"
kubectl -n "$namespace" get deployment,pods,service,endpoints -o wide
kubectl -n "$namespace" describe deployment "$deployment"
kubectl -n "$namespace" get events --sort-by=.lastTimestamp | tail -n 30
kubectl -n "$namespace" logs "deployment/$deployment" --all-containers=true --since=30m --tail=200
