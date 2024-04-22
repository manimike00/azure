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
#variable "client_id" {}
#variable "client_secret" {}
#variable "tenant_id" {}

# AD Groups
#variable "admin_group_object_ids" {
#  type = list(string)
#}

# AKS Policy
variable "azure_policy_enabled" {
  type = bool
}

# AppGW
#variable "gateway_id" {}

# Cluster Access
variable "private_cluster_enabled" {
  type = bool
}


# RBAC
variable "local_account_disabled" {
  type = bool
}

# workload identity
variable "oidc_issuer_enabled" {
  type = bool
}
variable "workload_identity_enabled" {
  type = bool
}

# network plugin
variable "network_plugin" {}
variable "network_policy" {}