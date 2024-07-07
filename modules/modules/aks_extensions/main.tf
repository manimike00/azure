resource "azurerm_kubernetes_cluster_extension" "ext" {
  name           = var.name
  cluster_id     = var.cluster_id
  extension_type = var.extension_type  #"microsoft.flux"
}