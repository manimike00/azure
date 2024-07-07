resource "azurerm_kubernetes_flux_configuration" "flux" {
  name       = var.name
  cluster_id = var.cluster_id
  namespace  = var.namespace

  git_repository {
    url                     = var.git_repo_url
    reference_type          = var.git_repo_reference_type
    reference_value         = var.git_repo_reference_value
    https_key_base64        = base64encode(var.https_key_base64)
    https_user              = var.https_user
  }

  kustomizations {
    name = var.kustomizations_name
    path = var.kustomizations_path

  }

}
