output "role_arn" {
  description = "IAM role ARN for External Secrets Operator"
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "IAM role name for External Secrets Operator"
  value       = aws_iam_role.this.name
}

output "policy_arn" {
  description = "IAM policy ARN for External Secrets Operator"
  value       = aws_iam_policy.this.arn
}
