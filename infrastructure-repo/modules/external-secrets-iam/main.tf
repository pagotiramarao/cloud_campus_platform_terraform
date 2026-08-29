data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "eso_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_url}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_url}:sub"
      values   = [
        "system:serviceaccount:external-secrets:external-secrets"
      ]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.environment}-external-secrets-role"
  assume_role_policy = data.aws_iam_policy_document.eso_assume_role.json

  tags = {
    Name        = "${var.environment}-external-secrets-role"
    Environment = var.environment
    Component   = "external-secrets"
  }
}

data "aws_iam_policy_document" "secrets_manager" {
  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    resources = [
      var.rds_secret_arn
    ]
  }
}

resource "aws_iam_policy" "this" {
  name        = "${var.environment}-external-secrets-secretsmanager"
  description = "Least-privilege access for External Secrets Operator to read the RDS secret"

  policy = data.aws_iam_policy_document.secrets_manager.json

  tags = {
    Name        = "${var.environment}-external-secrets-secretsmanager"
    Environment = var.environment
    Component   = "external-secrets"
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
