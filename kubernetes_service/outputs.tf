# resource group
output "resource_group" {
  value = module.resouce_group.resource-grp
}
output "resource_group_id" {
  value = module.resouce_group.resource-id
}
output "resource_group_location" {
  value = module.resouce_group.resource-location
}

# virtual network
output "virtual_network" {
  value = module.virtual_network.vnet
}
output "virtual_network_id" {
  value = module.virtual_network.vnet-id
}

# default nodepool subnet
output "default_nodepool_subnet" {
  value = module.default_np_subnet.subnets
}
output "default_nodepool_subnet_id" {
  value = module.default_np_subnet.subnets-id
}

# kubernetes service
output "aks" {
  value = module.kubernetes_service.aks
}
output "aks_id" {
  value = module.kubernetes_service.aks-id
}
output "aks_fqdn" {
  value = module.kubernetes_service.aks-fqdn
}

# backup storage account
output "backup_storage_account" {
  value = module.storage_account.storage_account
}
output "backup_storage_account_id" {
  value = module.storage_account.storage_account_id
}