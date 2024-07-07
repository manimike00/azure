resource "azurerm_container_registry" "acr" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.acr_sku

  admin_enabled = var.admin_enabled

  tags = {
    name        = var.name
    project     = var.project
    Location    = var.location
    environment = var.env
  }

}