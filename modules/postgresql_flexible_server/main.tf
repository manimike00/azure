resource "azurerm_postgresql_flexible_server" "postgresql_flexible_server" {
  location               = var.location
  name                   = var.name
  resource_group_name    = var.resource_group_name
  version                = var.postresql_version
  delegated_subnet_id    = var.delegated_subnet_id
  private_dns_zone_id    = var.private_dns_zone_id
  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password
  zone                   = var.zone
  storage_mb             = var.storage_mb
#  storage_tier           = var.storage_tier
  sku_name               = var.sku_name
  tags = {
    name        = var.name
    project     = var.project
    Location    = var.location
    environment = var.env
  }
}