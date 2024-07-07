variable "public_ip_address_id" {}
variable "nat_gateway_id" {}

resource "azurerm_nat_gateway_public_ip_association" "nat_gateway_public_ip_association" {
  nat_gateway_id       = var.nat_gateway_id
  public_ip_address_id = var.public_ip_address_id
}