output "role_arn" {
  description = "IAM role ARN for External DNS"
  value       = aws_iam_role.external_dns.arn
}

output "role_name" {
  description = "IAM role name for External DNS"
  value       = aws_iam_role.external_dns.name
}

output "policy_arn" {
  description = "IAM policy ARN for External DNS"
  value       = aws_iam_policy.external_dns.arn
}
