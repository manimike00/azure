module "resource_group" {
  source   = "../../modules/resource_group"
  name     = var.resource-group
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

module "subnet" {
  for_each = var.subnets

  source                     = "../../modules/subnets"
  name                       = each.value.name
  resource_group_name        = module.resource_group["resource-grp"]
  virtual_network_name       = module.virtual_network.vnet
  address_prefixes           = each.value.address_prefix
  service_endpoints          = each.value.service_endpoints
  service_delegation         = each.value.delegation == null ? null : each.value.delegation.name
  service_delegation_name    = each.value.delegation == null ? null : each.value.delegation.service_name
  service_delegation_actions = each.value.delegation == null ? null : each.value.delegation.actions
}
