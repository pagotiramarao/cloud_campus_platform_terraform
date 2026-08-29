output "endpoint" {
  value = aws_db_instance.this.address
}

output "port" {
  value = aws_db_instance.this.port
}

output "database_name" {
  value = aws_db_instance.this.db_name
}

output "username" {
  value     = aws_db_instance.this.username
  sensitive = true
}

output "security_group_id" {
  value = var.security_group_id
}

output "master_user_secret_arn" {
  description = "RDS-managed Secrets Manager secret ARN"
  value       = try(aws_db_instance.this.master_user_secret[0].secret_arn, null)
}
