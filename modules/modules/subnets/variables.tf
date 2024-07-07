variable "name" {}
variable "resource_group_name" {}
variable "virtual_network_name" {}
variable "address_prefixes" {}
variable "service_endpoints" {
  default = null
}
#variable "service_delegation" {
#  default = null
#}
#variable "service_delegation_name" {
#  default = null
#}
#variable "service_delegation_actions" {
#  type = list(string)
#  default = null
#}