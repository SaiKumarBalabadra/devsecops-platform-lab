module "platform" {
  source = "../../modules/platform"

  project                 = var.project
  environment             = "staging"
  vpc_cidr                = var.vpc_cidr
  availability_zone_count = var.availability_zone_count
  single_nat_gateway      = false
  kubernetes_version      = var.kubernetes_version
  instance_types          = var.instance_types
  node_desired_size       = 3
  node_min_size           = 2
  node_max_size           = 6
  public_endpoint_enabled = var.public_endpoint_enabled
  public_endpoint_cidrs   = var.public_endpoint_cidrs
  tags                    = var.tags
}
