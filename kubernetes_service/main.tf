# create reource group
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

# create subnet for default nodepool
module "default_np_subnet" {
  source               = "../modules/subnets"
  name                 = "${var.name}-system-np"
  address_prefixes     = var.address_prefixes_default_np
  resource_group_name  = module.resouce_group.resource-grp
  service_endpoints    = null
  virtual_network_name = module.virtual_network.vnet
}

# create kubernetes service
module "kubernetes_service" {
  source                 = "../modules/kubernetes_service"
  name                   = "${var.env}-${var.name}-${var.project}"
  env                    = var.env
  project                = var.project
  location               = var.location
  default-np-size        = "Standard_B2s"
  local_account_disabled = false
  resource-grp           = module.resouce_group.resource-grp
  vnet_subnet_id         = module.default_np_subnet.subnets-id
}

