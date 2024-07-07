# create resource group
module "resouce_group" {
  source   = "../modules/resource_group"
  name     = "${var.env}-${var.name}-${var.project}"
  env      = var.env
  location = var.location
  project  = var.project
}

# create virtual network
module "virtual_network" {
  source              = "../modules/virtual_network"
  name                = "${var.env}-${var.name}-${var.project}"
  project             = var.project
  location            = var.location
  env                 = var.env
  resource_group_name = module.resouce_group.resource-grp
  address_space       = var.address_space
}

# create subnet for postgresql nodepool
module "postgresql_subnet" {
  source                     = "../modules/subnets"
  name                       = "${var.env}-${var.name}-${var.project}-postgresql"
  address_prefixes           = var.address_prefixes_postgresql
  resource_group_name        = module.resouce_group.resource-grp
  virtual_network_name       = module.virtual_network.vnet
  service_endpoints          = ["Microsoft.Storage"]
  service_delegation         = "fs"
  service_delegation_name    = "Microsoft.DBforPostgreSQL/flexibleServers"
  service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
}

# private dns zone
module "private_dns_zone" {
  source              = "../modules/private_dns_zone"
  name                = "example.postgres.database.azure.com"
  project             = var.project
  location            = var.location
  env                 = var.env
  resource_group_name = module.resouce_group.resource-grp
}

# private dns zone vnet link
module "private_dns_zone_virtual_network_link" {
  source                = "../modules/private_dns_zone_vnet_link"
  domain                = "exampleVnetZone.com"
  name                  = "${var.env}-${var.name}-${var.project}"
  project               = var.project
  location              = var.location
  env                   = var.env
  private_dns_zone_name = module.private_dns_zone.private_dns_zone
  resource_group_name   = module.resouce_group.resource-grp
  virtual_network_id    = module.virtual_network.vnet-id
}

# postgresql flexible server
module "postgresql_flexible_server" {
  source                 = "../modules/postgresql_flexible_server"
  name                   = "${var.env}-${var.name}-${var.project}"
  project                = var.project
  location               = var.location
  env                    = var.env
  resource_group_name    = module.resouce_group.resource-grp
  postresql_version      = "12"
  delegated_subnet_id    = module.postgresql_subnet.subnets-id
  private_dns_zone_id    = module.private_dns_zone.private_dns_zone_id
  administrator_login    = "psqladmin"
  administrator_password = "H@Sh1CoR3!"
  zone                   = "1"
  storage_mb             = 32768
#  storage_tier           = "P30"
  sku_name               = "GP_Standard_D4s_v3"
}