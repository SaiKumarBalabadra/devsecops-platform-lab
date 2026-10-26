resource "aws_eks_cluster" "this" {
  name     = var.name
  role_arn = var.cluster_role_arn
  version  = var.kubernetes_version

  encryption_config {
    provider {
      key_arn = aws_kms_key.cluster_secrets.arn
    }
    resources = ["secrets"]
  }
  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }
  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = var.public_endpoint_enabled
    public_access_cidrs     = var.public_endpoint_enabled ? var.public_endpoint_cidrs : null
  }
  enabled_cluster_log_types = ["api", "audit", "authenticator"]
  tags                      = var.tags
}

resource "aws_kms_key" "cluster_secrets" {
  description             = "Encryption key for Kubernetes secrets in ${var.name}"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags                    = var.tags
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.name}-workers"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids
  instance_types  = var.instance_types

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }
  update_config {
    max_unavailable = 1
  }
  tags = var.tags
}
