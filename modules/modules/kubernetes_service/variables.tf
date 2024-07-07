variable "name" {}
variable "env" {}
variable "project" {}
variable "location" {}
variable "resource-grp" {}
variable "default-np-size" {}
variable "vnet_subnet_id" {}
variable "sku_tier" {
  default = "Free"
}
variable "cost_analysis_enabled" {
  default = false
}
variable "kubernetes_version" {}
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

# storage plugins
variable "blob_driver_enabled" {
  type = bool
}

variable "enable_auto_scaling" {
  type = bool
}
variable "max_count" {}
variable "min_count" {}
variable "node_count" {}
variable "private_dns_zone_id" {
  default = null
}
variable "private_cluster_public_fqdn_enabled" {
  type = bool
}

variable "identity" {
  default = "SystemAssigned"
}

variable "identity_ids" {
  default = null
}