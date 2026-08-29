variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region where ECR repositories exist"
  type        = string
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "jenkins_instance_id" {
  description = "Existing Jenkins EC2 instance ID"
  type        = string
}
