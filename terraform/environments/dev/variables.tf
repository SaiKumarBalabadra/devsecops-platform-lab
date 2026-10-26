variable "region" {
  type        = string
  description = "AWS region; provide explicitly using TF_VAR_region or terraform.tfvars."
}
variable "project" {
  type        = string
  description = "Resource naming prefix."
  default     = "platform-demo"
}
variable "vpc_cidr" {
  type        = string
  description = "Private IPv4 CIDR range."
  default     = "10.40.0.0/16"
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR."
  }
}
variable "availability_zone_count" {
  type        = number
  description = "Number of AZs used."
  default     = 2
  validation {
    condition     = var.availability_zone_count >= 2 && var.availability_zone_count <= 3
    error_message = "Choose two or three AZs."
  }
}
variable "kubernetes_version" {
  type        = string
  description = "EKS version available in the selected region."
  default     = "1.34"
}
variable "instance_types" {
  type        = list(string)
  description = "Managed worker node instance types."
  default     = ["t3.medium"]
}
variable "public_endpoint_enabled" {
  type        = bool
  description = "Enable public control-plane API access; disabled by default."
  default     = false
}
variable "public_endpoint_cidrs" {
  type        = list(string)
  description = "Approved IPv4 client ranges, required if public access is enabled."
  default     = []
  validation {
    condition     = length(var.public_endpoint_cidrs) == 0 || alltrue([for cidr in var.public_endpoint_cidrs : can(cidrnetmask(cidr))])
    error_message = "Each public endpoint CIDR must be valid IPv4."
  }
}
variable "tags" {
  type        = map(string)
  description = "Additional resource tags."
  default     = {}
}
