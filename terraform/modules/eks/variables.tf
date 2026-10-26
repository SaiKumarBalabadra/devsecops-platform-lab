variable "name" {
  type        = string
  description = "EKS cluster name."
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version selected for EKS."
  default     = "1.34"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs used by EKS."
}

variable "cluster_role_arn" {
  type        = string
  description = "Control plane IAM role ARN."
}

variable "node_role_arn" {
  type        = string
  description = "Managed node group IAM role ARN."
}

variable "instance_types" {
  type        = list(string)
  description = "EC2 instance types for nodes."
  default     = ["t3.medium"]
}

variable "desired_size" {
  type        = number
  description = "Desired managed node count."
  default     = 2
  validation {
    condition     = var.min_size <= var.desired_size && var.desired_size <= var.max_size
    error_message = "desired_size must be between min_size and max_size."
  }
}

variable "min_size" {
  type        = number
  description = "Minimum managed node count."
  default     = 2
}

variable "max_size" {
  type        = number
  description = "Maximum managed node count."
  default     = 4
}

variable "public_endpoint_enabled" {
  type        = bool
  description = "Enable the EKS public API endpoint. Private endpoint remains enabled."
  default     = false
  validation {
    condition     = !var.public_endpoint_enabled || length(var.public_endpoint_cidrs) > 0
    error_message = "Public API access requires one or more explicit client CIDRs."
  }
}

variable "public_endpoint_cidrs" {
  type        = list(string)
  description = "Explicit client CIDRs for the public cluster endpoint."
  default     = []
  validation {
    condition     = length(var.public_endpoint_cidrs) == 0 || alltrue([for cidr in var.public_endpoint_cidrs : can(cidrnetmask(cidr))])
    error_message = "Each public endpoint range must be a valid IPv4 CIDR."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to resources."
  default     = {}
}
