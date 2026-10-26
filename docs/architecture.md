# Architecture

## Runtime components

- **Application:** FastAPI ASGI service serves a static dashboard and health, readiness, build-info, and Prometheus endpoints. Request metrics use bounded route labels to avoid unbounded cardinality. JSON logs go to stdout.
- **Local runtime:** Docker Compose builds one container; only loopback port 8000 is published. It has a read-only root filesystem, no added capabilities, and no external services.
- **Cluster runtime:** Helm creates a Deployment, ClusterIP Service, tokenless ServiceAccount, ConfigMap, probes, resource controls, NetworkPolicy, and optional HPA/PDB/Ingress/ResourceQuota/LimitRange/ExternalSecret.
- **Delivery:** CI validates and scans. Publishing is limited to a commit-SHA tag from main. Argo CD watches Git and reconciles environment-specific Helm values.
- **Infrastructure:** Environment roots compose reusable VPC, IAM, EKS, ECR, and add-on modules. A private cluster endpoint is the default.
- **Operations:** Prometheus rules and Grafana dashboard cover golden signals and workload health. Alloy/Loki and OpenTelemetry are optional templates.

## Trust boundaries

1. Developer workstation and CI runner are untrusted until tests and configured scans pass.
2. Registry credentials are injected at runtime by CI credential stores and are never part of an image or repository.
3. GitOps configuration contains non-secret image references and configuration only.
4. Kubernetes admission policies are cluster-level enforcement examples; NetworkPolicy behavior depends on a CNI that enforces it.
5. AWS Terraform plans and state are sensitive. Remote state storage and locking must be provisioned and access-controlled independently.

## Network flow

The sample service has no outbound dependency. The chart's egress policy permits DNS only, and ingress is restricted to same-app pods, the configured ingress namespace, and monitoring namespace. Adjust selectors for the actual ingress controller and monitoring namespace, and validate against the installed CNI. The VPC example places EKS nodes in private subnets and permits NAT egress.

## Data flow

Application logs are JSON lines to stdout. Alloy discovers pods in `platform-demo-*` namespaces and forwards log entries to a configured Loki endpoint. Prometheus scrapes `/metrics`; dashboard and alert rules consume app metrics and optional kube-state-metrics/container metrics. The app itself does not send OTLP data.
