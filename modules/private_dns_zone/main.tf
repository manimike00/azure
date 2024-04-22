resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = var.name
  resource_group_name = var.resource_group_name
  tags = {
    name        = var.name
    project     = var.project
    Location    = var.location
    environment = var.env
  }
}