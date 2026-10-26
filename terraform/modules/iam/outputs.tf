output "cluster_role_arn" {
  description = "EKS control plane role ARN."
  value       = aws_iam_role.cluster.arn
}

output "node_role_arn" {
  description = "Managed node group role ARN."
  value       = aws_iam_role.nodes.arn
}
