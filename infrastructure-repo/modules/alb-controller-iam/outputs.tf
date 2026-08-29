output "role_arn" {
  value = aws_iam_role.alb_controller.arn
}

output "role_name" {
  value = aws_iam_role.alb_controller.name
}

output "policy_arn" {
  value = aws_iam_policy.alb_controller.arn
}
