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
  depends_on          = [module.resouce_group]
  source              = "../modules/virtual_network"
  name                = "${var.env}-${var.name}-${var.project}"
  project             = var.project
  location            = var.location
  env                 = var.env
  resource_group_name = module.resouce_group.resource-grp
  address_space       = var.address_space
}

# create subnet for postgresql nodepool
module "redis_subnet" {
  depends_on           = [module.virtual_network]
  source               = "../modules/subnets"
  name                 = "${var.env}-${var.name}-${var.project}-redis"
  address_prefixes     = var.address_prefixes_redis_cache
  resource_group_name  = module.resouce_group.resource-grp
  virtual_network_name = module.virtual_network.vnet
}

module "redis_cache" {
  depends_on                          = [module.redis_subnet]
  source                              = "../modules/redis_cache"
  name                                = "${var.env}-${var.name}-${var.project}"
  project                             = var.project
  location                            = var.location
  env                                 = var.env
  resource_group_name                 = module.resouce_group.resource-grp
  subnet_id                           = module.redis_subnet.subnets-id
  redis_cache_capacity                = 1
  redis_cache_family                  = "P"
  redis_cache_sku                     = "Premium"
  redis_enable_authentication         = false
  redis_public_network_access_enabled = false
}

module "redis_logs_storage_account" {
  depends_on          = [module.resouce_group]
  source              = "../modules/storage_account"
  name                = "${var.env}${var.name}${var.project}redis"
  project             = var.project
  location            = var.location
  env                 = var.env
  resource_group_name = module.resouce_group.resource-grp
}

module "redis_monitoring" {
  depends_on         = [module.redis_cache, module.redis_logs_storage_account]
  source             = "../modules/monitor_diagnostic_setting"
  name               = "${var.env}-${var.name}-${var.project}"
  target_resource_id = module.redis_cache.redis_id
  storage_account_id = module.redis_logs_storage_account.storage_account_id
}

