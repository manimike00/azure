variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "enabled_for_disk_encryption" {
  type    = bool
  default = true
}
variable "tenant_id" {}
variable "soft_delete_retention_days" {
  type = number
}
variable "purge_protection_enabled" {
  type    = bool
  default = false
}
variable "sku_name" {}
variable "enable_rbac_authorization" {
  default = true
}
