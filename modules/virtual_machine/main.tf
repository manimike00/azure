#resource "azurerm_public_ip" "public_ip" {
#  count               = var.type == "public" ? 1 : 0
#  name                = var.name
#  resource_group_name = var.resource_group_name
#  location            = var.location
#  allocation_method   = "Dynamic"
#}
#
#resource "azurerm_network_interface" "nic" {
#  name                = var.name
#  location            = var.location
#  resource_group_name = var.resource_group_name
#
#  ip_configuration {
#    name                          = var.name
#    subnet_id                     = var.subnet_id
#    private_ip_address_allocation = "Dynamic"
#    public_ip_address_id          = var.type == "public" ? azurerm_public_ip.public_ip[0].id : null
#  }
#}

resource "azurerm_linux_virtual_machine" "azure-vm" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  admin_username      = var.admin_username
  custom_data         = base64encode(var.custom_data)

  #  network_interface_ids = [
  #    azurerm_network_interface.nic.id,
  #  ]

  network_interface_ids = var.network_interface_ids
  identity {
    type = var.identity
    identity_ids = var.identity_ids
  }


  admin_ssh_key {
    username   = var.admin_username
    public_key = var.public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
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