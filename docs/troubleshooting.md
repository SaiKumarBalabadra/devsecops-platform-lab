# Troubleshooting guide

## Local app does not start

1. Check `docker compose ps` and `docker compose logs --tail=100 app`.
2. Verify port 8000 is free and the mapping is loopback-only.
3. Rebuild after dependency/image changes with `docker compose build --no-cache app`.
4. Query `curl -i http://127.0.0.1:8000/health` and `/ready`.

## Kubernetes pod is Pending or not Ready

Use `kubectl -n platform-demo-dev get pods -o wide`, `kubectl describe pod POD`, and `kubectl get events --sort-by=.lastTimestamp`. Check image pull access, quota/LimitRange, scheduling capacity, CPU/memory requests, and probe results. Use `bash scripts/diagnose-workload.sh`.

## CrashLoopBackOff

Inspect current and previous container logs with `kubectl logs POD --previous`, then inspect exit status/events. Common causes include invalid environment configuration, image/command mismatch, OOM kill, and a failing liveness probe. Follow [runbooks/crashloopbackoff.md](runbooks/crashloopbackoff.md).

## Metrics or dashboard is empty

Check `/metrics`, Prometheus target health, ServiceMonitor selectors/labels, namespace, scrape port, and whether the Prometheus Operator CRD is installed. Resource panels require cluster metrics exporters.

## Terraform validation fails

Run `terraform fmt -recursive terraform`, then from the environment directory use `terraform init -backend=false` and `terraform validate`. Initialization downloads providers but does not contact AWS or create infrastructure. AWS plans require region, credentials, quotas, and endpoint network access.
