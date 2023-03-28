output "appgw" {
  value = azurerm_application_gateway.network.name
}

output "appgw-id" {
  value = azurerm_application_gateway.network.id
}

#output "appgw-ip" {
#  value = azurerm_application_gateway.network.
#}