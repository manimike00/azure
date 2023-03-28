resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = var.name
  tags = {
    name        = var.name
    project     = var.project
    Location    = var.location
    environment = var.env
  }
  lifecycle {
    ignore_changes = [tags]
  }
}