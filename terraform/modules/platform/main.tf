locals {
  name = "${var.project}-${var.environment}"
  tags = merge(var.tags, {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "Terraform"
  })
}

module "vpc" {
  source                  = "../vpc"
  name                    = local.name
  cidr                    = var.vpc_cidr
  availability_zone_count = var.availability_zone_count
  single_nat_gateway      = var.single_nat_gateway
  tags                    = local.tags
}

module "iam" {
  source = "../iam"
  name   = local.name
  tags   = local.tags
}

module "eks" {
  source                  = "../eks"
  name                    = local.name
  kubernetes_version      = var.kubernetes_version
  subnet_ids              = module.vpc.private_subnet_ids
  cluster_role_arn        = module.iam.cluster_role_arn
  node_role_arn           = module.iam.node_role_arn
  instance_types          = var.instance_types
  desired_size            = var.node_desired_size
  min_size                = var.node_min_size
  max_size                = var.node_max_size
  public_endpoint_enabled = var.public_endpoint_enabled
  public_endpoint_cidrs   = var.public_endpoint_cidrs
  tags                    = local.tags
  depends_on              = [module.iam]
}

module "addons" {
  source          = "../addons"
  cluster_name    = module.eks.cluster_name
  cluster_version = var.kubernetes_version
  tags            = local.tags
}
