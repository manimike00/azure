output "private_vnet_link_name" {
  value = azurerm_private_dns_zone_virtual_network_link.private_vnet_link.name
}

output "private_vnet_link_id" {
  value = azurerm_private_dns_zone_virtual_network_link.private_vnet_link.id
}

output "private_dns_zone_name" {
  value = azurerm_private_dns_zone_virtual_network_link.private_vnet_link.private_dns_zone_name
}