variable "name" {}
variable "env" {}
variable "project" {}
variable "location" {}
variable "resource-grp" {}
variable "default-np-size" {}
variable "aks_subnet_prefix" {}
variable "vnet_name" {}
variable "address_space" {}
variable "sku_tier" {
  default = "Free"
}
variable "cost_analysis_enabled" {
  default = false
}
variable "kubernetes_version" {}
variable "private_cluster_enabled" {
  type = bool
}
variable "private_cluster_public_fqdn_enabled" {
  type = bool
}
variable "private_dns_zone_id" {
  default = null
}
variable "azure_policy_enabled" {
  type = bool
}
variable "local_account_disabled" {
  type = bool
}
variable "oidc_issuer_enabled" {
  type = bool
}
variable "workload_identity_enabled" {
  type = bool
}
variable "network_plugin" {}
variable "network_policy" {}
variable "blob_driver_enabled" {
  type = bool
}
variable "enable_auto_scaling" {
  type = bool
}
variable "max_count" {}
variable "min_count" {}
variable "node_count" {}
variable "identity" {
  default = "SystemAssigned"
}
variable "identity_ids" {
  default = null
}
