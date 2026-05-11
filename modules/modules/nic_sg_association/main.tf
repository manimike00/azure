resource "azurerm_network_interface_security_group_association" "nic_sg_bind" {
  network_interface_id = var.network_interface_id
  network_security_group_id = var.network_security_group_id
}


output "nic_sg_bind_id" {
  value = azurerm_network_interface_security_group_association.nic_sg_bind.id
}