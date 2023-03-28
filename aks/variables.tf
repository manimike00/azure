variable "name" {}
variable "env" {}
variable "project" {}
variable "location" {}
variable "resource-grp" {}
variable "default-np-size" {}
variable "vnet_subnet_id" {}
#variable "node_pools" {
#  type = list(string)
#}
#variable "vm_size" {
#  type = list(string)
#}

# Service Principles
variable "client_id" {}
variable "client_secret" {}
#variable "tenant_id" {}

# AD Groups
#variable "admin_group_object_ids" {
#  type = list(string)
#}

# AppGW
#variable "gateway_id" {}


# RBAC
variable "local_account_disabled" {
  type    = bool
}