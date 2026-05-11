resource "azurerm_network_security_group" "network_sg" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

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


output "network_sg" {
  value = azurerm_network_security_group.network_sg.name
}

output "network_sg_id" {
  value = azurerm_network_security_group.network_sg.id
}