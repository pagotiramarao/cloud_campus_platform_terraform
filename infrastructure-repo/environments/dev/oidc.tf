data "tls_certificate" "eks_oidc" {
  url = module.eks.oidc_issuer_url

  depends_on = [
    module.eks
  ]
}

resource "aws_iam_openid_connect_provider" "eks" {
  url = module.eks.oidc_issuer_url

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint
  ]

  depends_on = [
    module.eks,
    data.tls_certificate.eks_oidc
  ]
}
