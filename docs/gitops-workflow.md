# CI, promotion, and rollback

## Build and release

1. Open a pull request. CI runs tests, Ruff, filesystem/dependency/config/secret scan, Helm lint/render, and Terraform formatting. A failing configured HIGH/CRITICAL Trivy finding blocks the job.
2. Merge to `main`; GitHub Actions builds and scans the image. Only after a successful scan does it authenticate with the workflow token and publish a commit-SHA tag, then commit the matching development image tag to the GitOps values file. Jenkins mirrors the flow when the agent has the required tools and credential IDs.
3. Verify the registry digest and scan report. For production, add signature verification and signed provenance before deployment.

## Promotion

Dev and staging Argo CD Applications reconcile their respective values files automatically. `bash scripts/promote.sh dev COMMIT_SHA` (or `staging`/`prod`) changes the environment-specific image tag; inspect the diff, validate with Helm, and commit through review. Promote the same image reference through stages; do not rebuild between environments. Production sync is intentionally manual in Argo CD.

The promotion helper only edits a values file. CI performs the dev Git commit/push; the helper itself does not sync Argo CD or verify that the image exists.

## Rollback

- Preferred GitOps rollback: revert the environment tag commit and let Argo CD reconcile.
- Helm-managed local/imperative rollback: inspect history with `helm history RELEASE -n NAMESPACE`, then run `bash scripts/rollback.sh RELEASE NAMESPACE REVISION`.
- Confirm deployment availability and `/ready`, review metrics/logs, and record incident timeline.

## Drift detection

Argo CD compares live state with Git. `selfHeal` is enabled for dev/staging; production requires manual sync. Investigate drift in the Argo CD UI/CLI before syncing, because drift may be an emergency change or an unauthorized edit. Do not blindly prune resources without confirming ownership.

## External integrations

Replace example GitHub repository URLs, configure Argo CD repo credentials using its supported secret mechanism, grant the GitHub Actions image job narrow contents-write access for the dev promotion commit, and configure Jenkins with a username/password Git credential binding if used. Keep all tokens outside the repository/logs.
