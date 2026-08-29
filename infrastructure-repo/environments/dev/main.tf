module "vpc" {
  source = "../../modules/VPC"

  environment        = "dev"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["us-west-2a", "us-west-2b"]
}


module "security-group" {
  source                        = "../../modules/security-group"
  vpc_id                        = module.vpc.vpc_id
  eks_cluster_security_group_id = module.eks.cluster_security_group_id
}

module "rds" {
  source = "../../modules/rds"

  environment             = var.environment
  private_data_subnet_ids = module.vpc.private_data_subnet_ids
  security_group_id       = module.security-group.rds_sg_id

  db_name  = "cloudcampus"
  username = "cloudcampus"
}

module "external_secrets_iam" {
  source = "../../modules/external-secrets-iam"

  environment       = var.environment
  oidc_provider_arn = aws_iam_openid_connect_provider.eks.arn
  oidc_provider_url = aws_iam_openid_connect_provider.eks.url

  rds_secret_arn = module.rds.master_user_secret_arn

  depends_on = [
    aws_iam_openid_connect_provider.eks,
    module.rds
  ]
}


module "ecr" {
  source       = "../../modules/ecr"
  environment  = var.environment
  repositories = var.repositories
}


module "iam" {
  source      = "../../modules/iam"
  environment = var.environment
}


module "eks" {
  source             = "../../modules/eks"
  environment        = var.environment
  private_subnet_ids = module.vpc.private_app_subnet_ids
  node_role_arn      = module.iam.eks_node_role_arn
  cluster_role_arn   = module.iam.eks_cluster_role_arn
}

module "alb_controller_iam" {
  source = "../../modules/alb-controller-iam"

  environment       = var.environment
  oidc_provider_arn = aws_iam_openid_connect_provider.eks.arn
  oidc_provider_url = aws_iam_openid_connect_provider.eks.url

  depends_on = [
    aws_iam_openid_connect_provider.eks
  ]
}
module "external_dns_iam" {
  source = "../../modules/external-dns-iam"

  environment       = var.environment
  oidc_provider_arn = aws_iam_openid_connect_provider.eks.arn
  oidc_provider_url = aws_iam_openid_connect_provider.eks.url

  depends_on = [
    aws_iam_openid_connect_provider.eks
  ]
}
module "jenkins_iam" {
  source = "../../modules/jenkins-iam"

  environment         = var.environment
  aws_region          = "us-west-2"
  account_id          = "938379788459"
  jenkins_instance_id = "i-03a2cf3912697f3f9"
}

module "route53" {
  source      = "../../modules/route53"
  domain_name = "mybanking.shop"
  environment = var.environment
}


# resource "aws_ec2_tag" "karpenter_cluster_sg_discovery" {
#   resource_id = module.eks.cluster_security_group_id
#
#   key   = "karpenter.sh/discovery"
#   value = module.eks.cluster_name
# }


module "acm" {
  source         = "../../modules/acm"
  domain_name    = "mybanking.shop"
  hosted_zone_id = module.route53.route53_zone_id
  environment    = var.environment
}
