terraform {
  backend "s3" {
    bucket       = "tf-state-938379788459-01"
    key          = "dev/argocd/terraform.tfstate"
    region       = "us-west-2"
    use_lockfile = true
  }
}
