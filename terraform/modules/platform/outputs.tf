output "cluster_name" {
  description = "EKS cluster name."
  value       = module.eks.cluster_name
}
output "cluster_endpoint" {
  description = "Private EKS API endpoint."
  value       = module.eks.cluster_endpoint
}
output "vpc_id" {
  description = "VPC ID."
  value       = module.vpc.vpc_id
}
output "ecr_repository_url" {
  description = "Immutable ECR repository URL."
  value       = module.ecr.repository_url
}
