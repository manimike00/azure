# AKS service implementation
# This file wires up the aks module with the vnet and subnet infrastructure.
#
# The modules referenced mirror the vnet structure: resource_group, virtual_network, subnets, kubernetes_service.
#
# TODO: adjust resource group / subnet names and settings as needed.

module "resource_group" {
  source   = "../../modules/resource_group"
  name     = var.resource-grp
  location = var.location
  env      = var.env
  project  = var.project
}

module "virtual_network" {
  source              = "../../modules/virtual_network"
  name                = var.vnet_name
  location            = var.location
  env                 = var.env
  project             = var.project
  resource_group_name = module.resource_group["resource-grp"]
  address_space       = var.address_space
}

module "subnets" {
  for_each = {
    aks = {
      name           = "${var.name}-aks-subnet"
      address_prefix = var.aks_subnet_prefix
      service_endpoints = null
      delegation     = null
    }
  }

  source                     = "../../modules/subnets"
  name                       = each.value.name
  resource_group_name        = module.resource_group["resource-grp"]
  virtual_network_name       = module.virtual_network.vnet
  address_prefixes           = each.value.address_prefix
  service_endpoints          = each.value.service_endpoints
  service_delegation         = each.value.delegation == null ? null : each.value.delegation
}

module "aks" {
  source = "../../modules/kubernetes_service"
  name                 = var.name
  env                  = var.env
  project              = var.project
  location             = var.location
  resource-grp          = module.resource_group["resource-grp"]
  default-np-size       = var.default-np-size
  vnet_subnet_id       = module.subnets["aks"].subnets-id
  sku_tier              = var.sku_tier
  cost_analysis_enabled = var.cost_analysis_enabled
  kubernetes_version    = var.kubernetes_version
  private_cluster_enabled = var.private_cluster_enabled
  private_cluster_public_fqdn_enabled = var.private_cluster_public_fqdn_enabled
  private_dns_zone_id = var.private_dns_zone_id
  azure_policy_enabled = var.azure_policy_enabled
  local_account_disabled          = var.local_account_disabled
  oidc_issuer_enabled             = var.oidc_issuer_enabled
  workload_identity_enabled        = var.workload_identity_enabled
  network_plugin                 = var.network_plugin
  network_policy                 = var.network_policy
  blob_driver_enabled             = var.blob_driver_enabled
  enable_auto_scaling             = var.enable_auto_scaling
  max_count                      = var.max_count
  min_count                      = var.min_count
  node_count                     = var.node_count
  identity                       = var.identity
  identity_ids                   = var.identity_ids
}
