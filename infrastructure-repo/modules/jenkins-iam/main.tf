resource "aws_iam_role" "jenkins" {
  name = "${var.environment}-jenkins-ecr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "jenkins_ecr" {
  name = "${var.environment}-jenkins-ecr-policy"
  role = aws_iam_role.jenkins.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ecr:GetAuthorizationToken"
        ]

        Resource = "*"
      },
      {
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:DescribeImages",
          "ecr:UploadLayerPart"
        ]

        Resource = [
          "arn:aws:ecr:${var.aws_region}:${var.account_id}:repository/${var.environment}-frontend",
          "arn:aws:ecr:${var.aws_region}:${var.account_id}:repository/${var.environment}-backend"
        ]
      }
    ]
  })
}

resource "aws_iam_instance_profile" "jenkins" {
  name = "${var.environment}-jenkins-ecr-profile"
  role = aws_iam_role.jenkins.name
}
