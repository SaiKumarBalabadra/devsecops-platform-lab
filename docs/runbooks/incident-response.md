# Incident response runbook

1. **Declare and scope:** identify affected environment, start UTC timeline, assign incident lead, and communicate through approved channels.
2. **Assess impact:** check Argo CD sync/health, deployment desired/available replicas, service endpoints, probes, 5xx rate and latency.
3. **Stabilize:** pause promotion, roll back to the last known-good immutable image through Git, or use a reviewed Helm rollback for a non-GitOps local deployment.
4. **Diagnose:** inspect recent events and workload logs with the scripts in `scripts/`. Do not collect Kubernetes Secret objects. Treat logs and diagnostic output as potentially sensitive.
5. **Recover:** verify replicas, readiness, error rate, latency, and dependent infrastructure. Keep the incident open until user impact is cleared.
6. **Learn:** preserve a redacted timeline, identify contributing factors, and create owned actions for prevention/detection.

Never delete cluster resources or change cloud infrastructure as an exploratory action. Use approved change control.
