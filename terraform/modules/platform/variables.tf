variable "project" {
  type        = string
  description = "Project identifier used in names."
  default     = "platform-demo"
}
variable "environment" {
  type        = string
  description = "Deployment environment."
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be dev, staging, or prod."
  }
}
variable "vpc_cidr" {
  type        = string
  description = "VPC address range."
}
variable "availability_zone_count" {
  type        = number
  description = "Number of availability zones."
  default     = 2
}
variable "single_nat_gateway" {
  type        = bool
  description = "Use one NAT gateway to lower costs; this reduces AZ resilience."
}
variable "kubernetes_version" {
  type        = string
  description = "EKS Kubernetes version supported in the chosen AWS region."
}
variable "instance_types" {
  type        = list(string)
  description = "Managed node instance types."
}
variable "node_desired_size" {
  type        = number
  description = "Initial node group size."
}
variable "node_min_size" {
  type        = number
  description = "Node group minimum size."
}
variable "node_max_size" {
  type        = number
  description = "Node group maximum size."
}
variable "public_endpoint_enabled" {
  type        = bool
  description = "Enable public EKS API access (defaults false in environments)."
}
variable "public_endpoint_cidrs" {
  type        = list(string)
  description = "Approved public API client CIDRs."
  default     = []
}
variable "tags" {
  type        = map(string)
  description = "Additional AWS resource tags."
  default     = {}
}
