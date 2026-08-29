variable "environment" {
  description = "Environment name"
  type        = string
}

variable "private_data_subnet_ids" {
  description = "Private data subnet IDs for RDS"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for RDS"
  type        = string
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "cloudcampus"
}

variable "username" {
  description = "PostgreSQL master username"
  type        = string
  default     = "cloudcampus"
}
