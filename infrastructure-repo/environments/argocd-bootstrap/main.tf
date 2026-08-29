module "argocd_bootstrap" {
  source = "../../modules/argocd-bootstrap"

  gitops_repo_url = var.gitops_repo_url
  gitops_revision = var.gitops_revision

  providers = {
    kubernetes = kubernetes
  }
}
