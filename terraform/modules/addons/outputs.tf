output "managed_addon_names" {
  description = "Names of the managed EKS add-ons."
  value       = [aws_eks_addon.vpc_cni.addon_name, aws_eks_addon.coredns.addon_name, aws_eks_addon.kube_proxy.addon_name]
}
