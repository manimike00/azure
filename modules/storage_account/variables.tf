variable "name" {}
variable "env" {}
variable "project" {}
variable "resource_group_name" {}
variable "location" {}
variable "account_tier" {
  default = "Standard"
}
variable "account_replication_type" {
  default = "GRS"
}
