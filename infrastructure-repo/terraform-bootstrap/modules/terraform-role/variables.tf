variable "trusted_principal_arn" {
  description = "This is for terraform execution role for deployments"
  type        = string
}

variable "role_name" {
  description = "Name of the IAM role to be created for Terraform execution."
  type        = string
}