# Runbook: high request latency

**Signal:** `PlatformDemoHighP95Latency` fires above 500 ms for ten minutes.

1. Compare p50/p95/p99 latency with request rate and 5xx ratio.
2. Check CPU throttling, memory pressure, node capacity, restarts, and deployment changes.
3. Query logs for slow endpoints and correlate with revision/instance labels.
4. The optional `SIMULATE_SLOW_RESPONSE_MS` setting exists only for controlled local tests; ensure it is disabled outside those tests.
5. Scale only after identifying a capacity bottleneck; check HPA metrics availability and resource requests.
6. Validate latency recovery and document any capacity or performance changes.
