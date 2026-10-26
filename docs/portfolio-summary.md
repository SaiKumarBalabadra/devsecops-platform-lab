# Portfolio project summary

## Enterprise DevSecOps Platform Engineering Lab

**Role demonstrated:** Principal Platform Engineer / Senior DevOps / SRE / DevSecOps.

Designed a reproducible platform reference that carries a Python service from local development through testing, security gates, immutable image publication, Helm-based Kubernetes deployment, GitOps promotion, infrastructure provisioning definitions, and operational response.

### Engineering outcomes

- Delivered a FastAPI service with health/readiness endpoints, structured logging, bounded Prometheus metrics, static service-status UI, and tests.
- Built a multi-stage non-root container and a minimal local Docker Compose experience.
- Packaged the app in a hardened Helm chart with probes, resource governance, autoscaling, disruption budget, optional ingress, NetworkPolicy, External Secrets hooks, and environment overlays.
- Added CI examples for Jenkins and GitHub Actions, plus Argo CD promotion/rollback patterns.
- Authored reusable AWS Terraform modules for VPC/subnets, IAM, EKS, encrypted cluster secrets, ECR, and managed add-ons, separated by environment.
- Added admission policy/RBAC examples, scan gates, alert rules, dashboard queries, SLO guidance, and incident runbooks.

### Security and operations stance

The application pod has no Kubernetes API permissions; credentials are not embedded. Cloud creation is deliberately not automated. Security scans fail on configured HIGH/CRITICAL findings, while optional external integrations are clearly marked as templates until installed and tested. Network, registry, state backend, identity, policy enforcement, and monitoring must be adapted to the organization's actual cloud and cluster.

### Verification boundaries

Local tests, lint, chart rendering, Terraform formatting/static validation, and container build are reported separately from live-cluster, cloud, SonarQube, Argo CD, Kyverno, and monitoring integration tests. No AWS deployment or Terraform apply is part of this project.
