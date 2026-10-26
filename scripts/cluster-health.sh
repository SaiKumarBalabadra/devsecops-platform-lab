#!/usr/bin/env bash
set -euo pipefail
kubectl cluster-info
kubectl get nodes -o wide
kubectl get pods --all-namespaces --field-selector=status.phase!=Running,status.phase!=Succeeded
kubectl get events --all-namespaces --sort-by=.lastTimestamp | tail -n 30
