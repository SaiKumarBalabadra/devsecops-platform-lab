output "cluster_name" {
  value       = module.platform.cluster_name
  description = "EKS cluster name."
}
output "ecr_repository_url" {
  value       = module.platform.ecr_repository_url
  description = "Container image repository URL."
}
