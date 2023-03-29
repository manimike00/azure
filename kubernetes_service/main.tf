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

# create stoage account
module "storage_account" {
  source                   = "../modules/storage_account"
  name                     = "${var.env}${var.name}${var.project}backup"
  env                      = var.env
  location                 = var.location
  project                  = var.project
  resource_group_name      = module.resouce_group.resource-grp
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

# create storage container
module "storage_container" {
  source                = "../modules/storage_container"
  name                  = "velero"
  storage_account_name  = module.storage_account.storage_account
  container_access_type = "private"
}

# create kubernetes secrets
#module "velerosecret" {
#  source = "../modules/kubernetes_resources/secrets"
#  name = "velero"
#  data = {
#    HELLO=World
#  }
#  type = "Opaque"
#}

# deploy velero
module "elasticSearch" {
  source           = "../modules/helm_releases"
  name             = "velero"
  chart            = "velero"
  create_namespace = true
  namespace        = "velero"
  repository       = "https://vmware-tanzu.github.io/helm-charts"
  values = [
    { name = "configuration.provider", value = "azure", type = "string" },
    { name = "configuration.backupStorageLocation.name", value = "azure", type = "string" },
    { name = "configuration.backupStorageLocation.bucket", value = module.storage_account.storage_account, type = "string" },
    { name = "initContainers[0].name", value = "velero-plugin-for-csi", type = "string" },
    { name = "initContainers[0].image", value = "velero/velero-plugin-for-csi:v0.2.0", type = "string" },
    { name = "initContainers[0].imagePullPolicy", value = "IfNotPresent", type = "string" },
    { name = "initContainers[0].volumeMounts[0].mountPath", value = "/target", type = "string" },
    { name = "initContainers[0].volumeMounts[0].name", value = "plugins", type = "string" }
  ]
}
