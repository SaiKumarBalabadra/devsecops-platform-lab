resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = var.cluster_name
  addon_name                  = "vpc-cni"
  resolve_conflicts_on_update = "PRESERVE"
  tags                        = var.tags
}

resource "aws_eks_addon" "coredns" {
  cluster_name                = var.cluster_name
  addon_name                  = "coredns"
  resolve_conflicts_on_update = "PRESERVE"
  depends_on                  = [aws_eks_addon.vpc_cni]
  tags                        = var.tags
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name                = var.cluster_name
  addon_name                  = "kube-proxy"
  resolve_conflicts_on_update = "PRESERVE"
  depends_on                  = [aws_eks_addon.vpc_cni]
  tags                        = var.tags
}
