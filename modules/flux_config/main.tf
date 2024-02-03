resource "azurerm_kubernetes_flux_configuration" "example" {
  name       = var.name
  cluster_id = var.cluster_id
  namespace  = var.namespace

  git_repository {
    url                     = var.git_repo_url
    reference_type          = var.git_repo_reference_type
    reference_value         = var.git_repo_reference_value
    ssh_private_key_base64  = var.ssh_private_key_base64
    https_user              = var.https_user
  }

  kustomizations {
    name = "kustomization-1"
  }

}
