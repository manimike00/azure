# Terraform variables for a simple Azure Linux VM
# # Create a new VM that connects to the existing VNet.
# variable "vm_name" { }
# variable "vm_size" { }
variable "env" {}
variable "project" {}
# variable "admin_username" { }
# variable "admin_password" { }
variable "location" { }
variable "resource-group" { }
# variable "vnet_name" { }
# variable "subnet_name" { }
# variable "public_ip_name" { }
# variable "public_dns_name" { default = null }
# variable "custom_data" { default = null }
# variable "tags" { 
#     type = map(string)
#     default = {} 
# }
