output "vnet" {
  value = azurerm_virtual_network.vnet.name
}

output "vnet-id" {
  value = azurerm_virtual_network.vnet.id
}

#output "subnet_web" {
#  value = azurerm_subnet.subnets[0].id
#}
#
#output "subnet_app" {
#  value = azurerm_subnet.subnets[1].id
#}
#
#output "subnet_db" {
#  value = azurerm_subnet.subnets[2].id
#}

#output "aks_subnets_id" {
#  value = azurerm_subnet.aks-subnet.id
#}