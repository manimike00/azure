variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "env" {}
variable "project" {}

variable "subnet_id" {}
variable "virtual_network_name" {}
variable "public_ip_address_id" {}
variable "private_ip_address_allocation" {}
variable "private_ip_address" {}

#SKU
variable "sku-name" {}
variable "sku-tier" {}
variable "sku-capacity" {}

#WAF
variable "firewall_policy_id" {}