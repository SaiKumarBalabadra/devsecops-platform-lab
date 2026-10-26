# Security model and controls

## Assets and threats

The principal assets are source integrity, registry credentials/images, Kubernetes workload availability, AWS Terraform state, and CI/GitOps credentials. Relevant threats include vulnerable dependencies, malicious image substitution, accidental privilege escalation, secret leakage in logs, exposed APIs, overly broad cluster/network access, and unreviewed cloud changes.

## Implemented examples

- Source and dependency Trivy filesystem scan; image Trivy scan in GitHub Actions and Jenkins; HIGH/CRITICAL findings fail configured pipeline scans.
- Python dependencies and container base image use explicit versions. Container runs UID 10001 with a read-only filesystem in Kubernetes/Compose, disabled privilege escalation, dropped capabilities, and health checks.
- Helm defines resource requests/limits, seccomp `RuntimeDefault`, tokenless ServiceAccount, and NetworkPolicy.
- Kyverno policy examples reject privileged/root containers, missing requests/limits, and mutable `latest` tags.
- Optional namespace Role grants read-only workload/event/log inspection only.
- CI secrets are injected as credentials; no real secrets are included in environment examples.
- External Secrets remains disabled until the operator, secret store, IAM integration, and source paths are configured.
- Terraform defaults to a private EKS API and encrypted remote state examples.

## Boundaries and non-claims

CI scan actions are configured but their latest database results have not been asserted until the workflow runs. No AWS resource, cluster policy, SonarQube server, Argo CD controller, External Secrets controller, signing system, or monitoring backend is installed here. The app does not currently export traces. CI action tags should be replaced with verified commit SHAs for high-assurance supply-chain controls.

The JSON formatter redacts extra log fields whose names contain common secret markers. This is defense in depth, not a substitute for not logging credentials; exception messages and arbitrary application text can still carry sensitive data.

## Operational guidance

Use short-lived CI identity where possible; restrict registry write permissions to release jobs. Review Trivy findings and update pins rather than adding broad ignores. Apply Kyverno policies first in audit mode in a representative cluster, evaluate existing workloads, then enforce through change control. Verify NetworkPolicy enforcement with the chosen CNI. Protect state bucket access/versioning, restrict backend access, and do not store `tfplan` artifacts in an untrusted pipeline.
