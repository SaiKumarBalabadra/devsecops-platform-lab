# Runbook: elevated 5xx responses

**Signal:** `PlatformDemoHighErrorRate` fires when the five-minute 5xx ratio stays above 5% for ten minutes.

1. Confirm the alert and query `sum by (path,status) (rate(http_requests_total{status=~"5.."}[5m]))`.
2. Check current rollout and recent image/tag changes in Argo CD.
3. Inspect application logs, readiness, pod events, and CPU/memory saturation.
4. If tied to a recent release, revert the environment image tag through a reviewed Git change; confirm recovery before resuming promotion.
5. If ongoing, check node/network/DNS and external dependencies (the sample app has none by default).
6. Record duration, affected request volume, and follow-up actions.

Do not infer a user-facing availability SLO from this alert alone; inspect traffic volume and exclusions.
