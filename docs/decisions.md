# Architecture decisions

## ADR 001: Helm is the Kubernetes source of truth

**Decision:** Maintain one Helm chart with environment-specific values rather than a parallel Kustomize copy.

**Reason:** The workload has optional resources and a small set of environment differences. A second renderer would duplicate defaults and increase drift risk. Revisit if an environment needs patch composition that is materially clearer in Kustomize.

## ADR 002: Lightweight local default

**Decision:** Default Compose runs only the app.

**Reason:** A developer can verify the core service without installing or running a monitoring suite, registry, cluster, or cloud resources. Observability configs remain optional integration assets.

## ADR 003: Immutable deployment references

**Decision:** CI tags published images with the source commit SHA; environment promotion updates a Helm value in Git.

**Reason:** A reviewed Git change is auditable and rollbackable. Production remains manually synchronized. Registry tag immutability and digest pinning should be enforced by the eventual registry/cluster policy.

## ADR 004: No app Kubernetes API credentials

**Decision:** The app uses a tokenless ServiceAccount and requests no Role/RoleBinding.

**Reason:** It does not need to query or mutate Kubernetes. A separate opt-in namespace Role lets human operators inspect workloads/logs without granting app privileges.

## ADR 005: Private EKS control plane by default

**Decision:** Terraform disables the public API endpoint by default.

**Reason:** It reduces public attack surface. Operators need approved network connectivity to the VPC endpoint; enabling public access requires explicit client CIDRs and review.

## ADR 006: No automatic cloud apply

**Decision:** Repository examples and local validation never invoke Terraform apply.

**Reason:** Cloud resource creation and cost must remain an explicit human action with reviewed plan, permissions, and budget.
