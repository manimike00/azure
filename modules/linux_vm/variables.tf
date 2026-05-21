variable "name" {}
variable "resource_group_name" {}
variable "location" {}
variable "vm_size" {}
variable "admin_username" {}
variable "admin_password" {}
variable "network_interface_ids" { type = list(string) }
variable "identity" { default = "SystemAssigned" }
variable "identity_ids" { default = null }
variable "custom_data" { default = null }
variable "storage_account_type" { default = "Standard_LRS" }
variable "publisher" { default = "Canonical" }
variable "offer" { default = "UbuntuServer" }
variable "sku" { default = "18.04-LTS" }
variable "os_version" { default = "latest" }
variable "tags" { type = map(string); default = {} }
