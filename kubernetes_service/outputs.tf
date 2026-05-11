## resource group
#output "resource_group" {
#  value = module.resouce_group.resource-grp
#}
#output "resource_group_id" {
#  value = module.resouce_group.resource-id
#}
#output "resource_group_location" {
#  value = module.resouce_group.resource-location
#}
#
## virtual network
#output "virtual_network" {
#  value = module.virtual_network.vnet
#}
#output "virtual_network_id" {
#  value = module.virtual_network.vnet-id
#}
#
## default nodepool subnet
#output "default_nodepool_subnet" {
#  value = module.default_np_subnet.subnets
#}
#output "default_nodepool_subnet_id" {
#  value = module.default_np_subnet.subnets-id
#}
#
### kubernetes service
##output "aks" {
##  value = module.kubernetes_service.aks
##}
##output "aks_id" {
##  value = module.kubernetes_service.aks-id
##}
##output "aks_fqdn" {
##  value = module.kubernetes_service.aks-fqdn
##}
##
##output "aks-cluster_oidc_url" {
##  value = module.kubernetes_service.aks-cluster_oidc_url
##}
#
##output "ingress_application_gateway" {
##  value = module.kubernetes_service.ingress_application_gateway
##}
#
##output "appgw_uid" {
##  value = module.appgw_uid.uai_id
##}
##
##output "appgw_client_id" {
##  value = module.appgw_uid.uai_client_id
##}
#
##output "blob_driver_uid" {
##  value = module.blob_driver_uid.uai_id
##}
##
##output "blob_driver_client_id" {
##  value = module.blob_driver_uid.uai_client_id
##}
#
### References
##
##output "client_id" {
##  value = tolist([for item in module.kubernetes_service.ingress_application_gateway : item.ingress_application_gateway_identity[0].client_id])
##}
##
##output "gateway_id" {
##  value = tolist([for item in module.kubernetes_service.ingress_application_gateway : item.gateway_id])
##}
##
##output "user_assigned_identity_id" {
##  value = local.ingress_application_gateway_identity[0][0].user_assigned_identity_id
##}
##
### backup storage account
##output "backup_storage_account" {
##  value = module.storage_account.storage_account
##}
##output "backup_storage_account_id" {
##  value = module.storage_account.storage_account_id
##}