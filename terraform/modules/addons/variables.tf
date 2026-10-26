variable "cluster_name" {
  type        = string
  description = "EKS cluster name."
}

variable "cluster_version" {
  type        = string
  description = "EKS Kubernetes version."
}
variable "tags" {
  type        = map(string)
  description = "Tags applied to resources."
  default     = {}
}
