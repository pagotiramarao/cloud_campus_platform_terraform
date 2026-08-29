module "argocd" {
  source = "../../modules/argocd"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}
