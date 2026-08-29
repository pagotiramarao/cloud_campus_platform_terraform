data "aws_iam_policy_document" "external_dns_assume_role" {
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
      variable = "${replace(var.oidc_provider_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"
      values   = [
        "system:serviceaccount:external-dns:external-dns"
      ]
    }
  }
}

resource "aws_iam_role" "external_dns" {
  name = "${var.environment}-external-dns-role"

  assume_role_policy = data.aws_iam_policy_document.external_dns_assume_role.json

  tags = {
    Name        = "${var.environment}-external-dns-role"
    Environment = var.environment
    Component   = "external-dns"
  }
}

data "aws_iam_policy_document" "external_dns" {
  statement {
    effect = "Allow"

    actions = [
      "route53:*"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "external_dns" {
  name        = "${var.environment}-external-dns-route53"
  description = "IAM policy for External DNS to manage Route53"

  policy = data.aws_iam_policy_document.external_dns.json

  tags = {
    Name        = "${var.environment}-external-dns-route53"
    Environment = var.environment
    Component   = "external-dns"
  }
}

resource "aws_iam_role_policy_attachment" "external_dns" {
  role       = aws_iam_role.external_dns.name
  policy_arn = aws_iam_policy.external_dns.arn
}
