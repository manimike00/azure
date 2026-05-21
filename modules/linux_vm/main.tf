resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = var.network_interface_ids
  identity {
    type        = var.identity
    identity_ids = var.identity_ids
  }
  custom_data = var.custom_data
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.storage_account_type
  }
  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.os_version
  }
  tags = var.tags
}
