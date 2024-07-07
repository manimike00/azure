resource "azurerm_nat_gateway" "nat_gateway" {
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
  tags = {
    name        = var.name
    project     = var.project
    Location    = var.location
    environment = var.env
  }
}


output "nat_gw" {
  value = azurerm_nat_gateway.nat_gateway.name
}

output "nat_gw_id" {
  value = azurerm_nat_gateway.nat_gateway.id
}