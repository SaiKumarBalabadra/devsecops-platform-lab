variable "name" {
  type        = string
  description = "Prefix for the VPC and subnet resources."
}

variable "cidr" {
  type        = string
  description = "IPv4 CIDR block for the VPC."
  default     = "10.40.0.0/16"
  validation {
    condition     = can(cidrnetmask(var.cidr))
    error_message = "cidr must be a valid IPv4 CIDR block."
  }
}

variable "availability_zone_count" {
  type        = number
  description = "Number of availability zones used by the cluster."
  default     = 2
  validation {
    condition     = var.availability_zone_count >= 2 && var.availability_zone_count <= 3
    error_message = "Use two or three availability zones."
  }
}

variable "single_nat_gateway" {
  type        = bool
  description = "Share one NAT gateway (lower cost, not AZ resilient)."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to created resources."
  default     = {}
}
