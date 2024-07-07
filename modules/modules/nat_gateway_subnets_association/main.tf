variable "nat_gateway_id" {}
variable "subnet_id" {}

resource "azurerm_subnet_nat_gateway_association" "nat_gateway_subnet_association" {
  subnet_id      = var.subnet_id
  nat_gateway_id = var.nat_gateway_id
}
