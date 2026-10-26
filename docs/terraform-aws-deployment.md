# Terraform and AWS deployment guide

## Scope and safety

Terraform in this repository describes billable AWS resources. **Do not run `terraform apply` unless an authorized owner has explicitly approved the plan and cost.** This lab has not created or destroyed AWS resources. `terraform validate` is static; `terraform plan` contacts AWS and can expose account metadata in its output.

## State strategy

Use a dedicated pre-created S3 bucket with versioning, encryption, public-access blocks, and restrictive IAM/KMS policy. The backend examples enable S3 native lockfiles (`use_lockfile = true`). Keep state in separate keys by environment, protect plans/state artifacts, and define recovery/retention procedures. The bucket and its access policy are deliberately not provisioned by this stack.

Copy an environment `backend.tf.example` only after the backend exists; replace both state bucket and region placeholders. Use AWS role-based credentials or the standard AWS credential chain. Never place access keys in `.tf`, `.tfvars`, environment examples, or CI logs.

## Static validation

```bash
terraform fmt -recursive terraform
cd terraform/environments/dev
terraform init -backend=false
terraform validate
```

No AWS credentials are needed for `validate`, but initialization downloads provider plugins. `terraform plan` needs account access and evaluates availability/quotas in the chosen region. Review every create/replace/destroy action and estimate NAT, EKS control plane, EC2, logging, and storage costs before approval.

## Module layout

- `modules/vpc`: VPC, public/private subnets, internet/NAT gateways, routes.
- `modules/iam`: EKS control-plane and node roles with AWS-managed baseline policies.
- `modules/eks`: private endpoint EKS cluster, managed node group, audit/control-plane logs.
- `modules/ecr`: immutable repository, scan-on-push, untagged image lifecycle policy.
- `modules/addons`: VPC CNI, CoreDNS, kube-proxy managed add-ons.
- `modules/platform`: composition and common tags.
- `environments/{dev,staging,prod}`: sizing and network examples.

The sample node role uses AWS-managed EKS worker policies for clarity; production deployments should move VPC CNI permissions to a dedicated IRSA/EKS Pod Identity role, review all managed policy permissions, and configure add-on versions supported by the target cluster/region. EKS Kubernetes Secrets are encrypted with a rotating customer-managed KMS key; the key has a 30-day deletion window and incurs KMS charges.

## Access and recovery

The EKS API public endpoint is disabled by default. Use an approved private network path. If public access is required, set `public_endpoint_enabled=true` and provide narrow approved `public_endpoint_cidrs`; never use `0.0.0.0/0`. Preserve remote-state versions and use the established state recovery process. Environment deletion requires a separately approved, reviewed destroy plan; no destroy automation is provided here.

## Cleanup and cost warning

This repository created no AWS resources. If an authorized deployment is later made, inventory state and dependencies, then create an environment-scoped `terraform plan -destroy -out=cleanup.tfplan` for review. Apply only after explicit change approval. EKS, NAT gateways, KMS keys, logging, and ECR storage can incur charges; deletion can cause data loss or outages. Never delete a shared state bucket as part of application-environment cleanup.
