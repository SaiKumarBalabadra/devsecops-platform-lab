# SLO and error budget example

This is a teaching target, not a measured service commitment.

## Service-level objectives

- **Availability:** 99.9% of valid HTTP requests return a non-5xx response over a rolling 30-day window. Exclude `/metrics` scrapes and synthetic probe traffic in a production query.
- **Latency:** 95% of user-facing requests complete in under 500 ms over a rolling 30-day window.

For a 30-day month, 99.9% availability permits approximately 43.2 minutes of unavailability. Use request-based SLIs so low-traffic time does not mask user impact. Current sample alert rules use short-window 5xx ratio and p95 latency as operational alerts, not full SLO burn-rate alerts.

## Error budget policy

Budget = allowed bad events under the SLO. Track remaining budget and burn rate; when the budget is exhausted, prioritize reliability work and require explicit risk acceptance before high-risk changes. A production service should use multi-window burn-rate alerts and a durable SLI store, neither of which is wired to a running backend in this lab.

## Metrics

The application exports `http_requests_total`, `http_request_duration_seconds_bucket`, and `http_requests_in_progress`. CPU/memory dashboards and restart/replica alerts require Kubernetes/container metrics such as kube-state-metrics and kubelet/cAdvisor, which are not installed by the app chart.
