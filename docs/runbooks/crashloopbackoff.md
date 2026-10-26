# Runbook: CrashLoopBackOff

1. Identify the pod/container and inspect `kubectl describe pod`.
2. Read current and previous logs (`kubectl logs POD -c CONTAINER --previous`) and pod termination reason.
3. Check invalid configuration, image digest/tag, startup/liveness probe path, OOMKilled status, resource limits, and mount permissions.
4. Correct the configuration or revert the last known-good GitOps revision; do not repeatedly delete pods as a fix.
5. Confirm Ready replicas and stable restart count. Capture redacted diagnostics if an incident is active.
