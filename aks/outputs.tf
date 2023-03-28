output "aks" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "aks-id" {
  value = azurerm_kubernetes_cluster.aks.id
}

output "aks-fqdn" {
  value = azurerm_kubernetes_cluster.aks.fqdn
}

#output "aks-host" {
#  value = azurerm_kubernetes_cluster.aks.kube_config.0.host
#}

#output "aks-client_certificate" {
#  value = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
#}
#
#output "aks-client_key" {
#  value = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
#}
#
#output "aks-cluster_ca_certificate" {
#  value = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
#}