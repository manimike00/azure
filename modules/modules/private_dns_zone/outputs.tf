output "private_dns_zone" {
  value = azurerm_private_dns_zone.private_dns_zone.name
}

output "private_dns_zone_id" {
  value = azurerm_private_dns_zone.private_dns_zone.id
}