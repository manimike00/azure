resource "azurerm_network_interface" "nic" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = var.name
    public_ip_address_id          = var.public_ip_address_id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
  }

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