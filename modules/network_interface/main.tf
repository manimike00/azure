resource "azurerm_network_interface" "nic" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "primary"
    subnet_id                     = var.subnet_id
    public_ip_address_id          = var.public_ip_address_id
    private_ip_address_allocation = "Dynamic"
  }
}
