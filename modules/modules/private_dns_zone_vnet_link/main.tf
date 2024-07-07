resource "azurerm_private_dns_zone_virtual_network_link" "private_vnet_link" {
  name                  = var.name
  private_dns_zone_name = var.private_dns_zone_name
  resource_group_name   = var.resource_group_name
  virtual_network_id    = var.virtual_network_id
  tags = {
    name        = var.name
    project     = var.project
    Location    = var.location
    environment = var.env
  }
}