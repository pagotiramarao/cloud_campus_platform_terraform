output "root_application_name" {
  value = kubernetes_manifest.root_app.manifest.metadata.name
}
