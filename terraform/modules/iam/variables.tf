variable "name" {
  type        = string
  description = "Prefix for IAM role names."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to resources that support tags."
  default     = {}
}
