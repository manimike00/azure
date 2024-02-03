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
  source                    = "../modules/kubernetes_service"
  name                      = "${var.env}-${var.name}-${var.project}"
  env                       = var.env
  project                   = var.project
  location                  = var.location
  default-np-size           = "Standard_B2s"
  local_account_disabled    = false
  resource-grp              = module.resouce_group.resource-grp
  vnet_subnet_id            = module.default_np_subnet.subnets-id
  private_cluster_enabled   = false
  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  azure_policy_enabled      = false
  #  gateway_id                = module.appgw.appgw-id
  #  client_id               = var.client_id
  #  client_secret           = var.client_secret
  #  tenant_id               = var.tenant_id
}

#locals {
#  ingress_application_gateway_identity = tolist([for item in module.kubernetes_service.ingress_application_gateway : item.ingress_application_gateway_identity])
#}

# Add AKS extensions
#module "flux_ext" {
#  source         = "../modules/aks_extensions"
#  name           = "${var.env}-${var.name}-${var.project}"
#  cluster_id     = module.kubernetes_service.aks-id
#  extension_type = "microsoft.flux"
#}

# Add Flux Configs
#module "flux_configs" {
#  depends_on = [module.flux_ext]
#  source = "../modules/flux_config"
#  name = "${var.env}-${var.name}-${var.project}"
#  cluster_id = module.kubernetes_service.aks-id
#  namespace = "flux"
#  git_repo_url = "git@github.com:manimike00/flux.git"
#  git_repo_reference_type = "branch"
#  git_repo_reference_value = "main"
#  ssh_private_key_base64 = "c3NoLXJzYSBBQUFBQjNOemFDMXljMkVBQUFBREFRQUJBQUFCZ1FEUHhMcjRGR3BzUHNZL2Nxa1Frb1F5R0dOeVM5NlNKaFNDMit0dVFZd3hmdVdlY2FKS1BnUjJnTTNRS0pTTkR2T3dQUnVXMDErSkdpQXRGM2lzRzJiR24xK2o2cXhWY1JuMmFLd0NHZVMvRE1lTjVnYUg1QStubVBScXl1bXMyY2ZaZEVTYkpvQVAzRm10MGhCUFhlRWFiakh0dkwrTkJpdnU4TW02ODNhY255dVZoeEV2anl2aEIzbkpOZ3J2MWE5em55OHpZZk0vU1B3NENkdVIxYllNb3RsanhVaEF1V05pZlFWTGZrc1dsQmZhRHM2Y1NkTjhJY09EQUloZ1pjcWcyVzJqa09mYllKTU5FVXFSZTVoTzlhbW9zQmEwcExmVHhUNkUwRTRNTDZxeWFqQXhnSko3L2phUFVKc0x3S2QrcTNzNTI3L25FSHBUellOSXhacFZqTEEweU5UZld4OGNST1RXUGdwclY5dkYxWnVLTEVkUlY2bUpVODhUWWpZN3lwNWFRZERKM2RNQ3RmSE5yNmR1Wll3VEhEMFh0MHhPaGwyYWVMNFdUaFhMN3g0SkhZR1JVV2N1aURUM2JqMXFvS0h4dlJQM1A0dStHYW9yY0VBUTViWk50ZnlkTzRMTTdhSkVjZml0TXFmUzFUQjFFaEdNMDFoKzhKZFhRems9IEF6dXJlQUQrTWFuaWthbmRhblNAUkNTTFAwMTIx"
#  https_user = "manimike00"
#}

## create subnets nodepool
#module "nodepool_subnets" {
#  source               = "../modules/subnets"
#  name                 = "${var.env}-${var.name}-${var.project}"
#  address_prefixes     = var.address_prefixes_monitoring_np
#  resource_group_name  = module.resouce_group.resource-grp
#  service_endpoints    = null
#  virtual_network_name = module.virtual_network.vnet
#}

## create user node pool
#module "monitoring" {
#  source                = "../modules/node_pool"
#  name                  = "monitoring"
#  env                   = var.env
#  environment           = var.env
#  location              = var.location
#  project               = var.project
#  kubernetes_cluster_id = module.kubernetes_service.aks-id
#  min_count             = 1
#  max_count             = 3
#  node_count            = 1
#  use_spot              = false
#  vm_size               = "Standard_B2s"
#  vnet_subnet_id        = module.nodepool_subnets.subnets-id
#}

## create stoage account
#module "storage_account" {
#  source                   = "../modules/storage_account"
#  name                     = "${var.env}${var.name}${var.project}backup"
#  env                      = var.env
#  location                 = var.location
#  project                  = var.project
#  resource_group_name      = module.resouce_group.resource-grp
#  account_tier             = "Standard"
#  account_replication_type = "GRS"
#}

## create storage container
#module "storage_container" {
#  source                = "../modules/storage_container"
#  name                  = "velero"
#  storage_account_name  = module.storage_account.storage_account
#  container_access_type = "private"
#}

#locals {
#  azure_creds = <<EOF
#AZURE_SUBSCRIPTION_ID=${var.subscription_id}
#AZURE_TENANT_ID=${var.tenant_id}
#AZURE_CLIENT_ID=${var.client_id}
#AZURE_CLIENT_SECRET=${var.client_secret}
#AZURE_RESOURCE_GROUP=${module.resouce_group.resource-grp}
#AZURE_CLOUD_NAME=AzurePublicCloud
#EOF
#}

# deploy velero
#module "velero" {
#  source           = "../modules/helm_releases"
#  name             = "velero"
#  chart            = "velero"
#  create_namespace = true
#  namespace        = "velero"
#  chart_version    = "3.1.3"
#  repository       = "https://vmware-tanzu.github.io/helm-charts"
#  values = [
#    { name = "initContainers[0].name", value = "velero-plugin-for-azure", type = "string" },
#    { name = "initContainers[0].image", value = "velero/velero-plugin-for-microsoft-azure:v1.5.0", type = "string" },
#    { name = "initContainers[0].imagePullPolicy", value = "IfNotPresent", type = "string" },
#    { name = "initContainers[0].volumeMounts[0].mountPath", value = "/target", type = "string" },
#    { name = "initContainers[0].volumeMounts[0].name", value = "plugins", type = "string" },
#    { name = "credentials.secretContents.cloud", value = local.azure_creds, type = "string" },
#    { name = "configuration.provider", value = "azure", type = "string" },
#    { name = "configuration.backupStorageLocation.bucket", value = module.storage_container.storage_container, type = "string" },
#    { name = "configuration.backupStorageLocation.config.resourceGroup", value = module.resouce_group.resource-grp, type = "string" },
#    { name = "configuration.backupStorageLocation.config.storageAccount", value = module.storage_account.storage_account, type = "string" },
#    { name = "configuration.backupStorageLocation.config.subscriptionId", value = var.subscription_id, type = "string" },
#    { name = "configuration.backupStorageLocation.default", value = "true", type = "string" }
#  ]
#}

# random password
#resource "random_password" "password" {
#  length           = 16
#  special          = true
#  override_special = "!#$%&*()-_=+[]{}<>:?"
#}

# deploy kube-prometheus-stack
#module "kube-prometheus-stack" {
#  source           = "../modules/helm_releases"
#  name             = "kube-prometheus-stack"
#  chart            = "kube-prometheus-stack"
#  chart_version    = "45.8.1"
#  create_namespace = true
#  namespace        = "monitoring"
#  repository       = "https://prometheus-community.github.io/helm-charts"
#  values = [
#    # scrape configs for opencost
#    { name = "prometheus.prometheusSpec.additionalScrapeConfigs[0].job_name", value = "opencost", type = "string"},
#    { name = "prometheus.prometheusSpec.additionalScrapeConfigs[0].scrape_interval", value = "1m", type = "string"},
#    { name = "prometheus.prometheusSpec.additionalScrapeConfigs[0].scrape_timeout", value = "10s", type = "string"},
#    { name = "prometheus.prometheusSpec.additionalScrapeConfigs[0].metrics_path", value = "/metrics", type = "string"},
#    { name = "prometheus.prometheusSpec.additionalScrapeConfigs[0].scheme", value = "http", type = "string"},
#    { name = "prometheus.prometheusSpec.additionalScrapeConfigs[0].static_configs[0].targets[0]", value = "opencost.opencost.svc.cluster.local:9003", type = "string"},
#    # scrape configs for velero
#    { name = "prometheus.prometheusSpec.additionalScrapeConfigs[1].job_name", value = "velero", type = "string"},
#    { name = "prometheus.prometheusSpec.additionalScrapeConfigs[1].scrape_interval", value = "30s", type = "string"},
#    { name = "prometheus.prometheusSpec.additionalScrapeConfigs[1].scrape_timeout", value = "10s", type = "string"},
#    { name = "prometheus.prometheusSpec.additionalScrapeConfigs[1].metrics_path", value = "/metrics", type = "string"},
#    { name = "prometheus.prometheusSpec.additionalScrapeConfigs[1].scheme", value = "http", type = "string"},
#    { name = "prometheus.prometheusSpec.additionalScrapeConfigs[1].static_configs[0].targets[0]", value = "velero.velero.svc.cluster.local:8085", type = "string"},
#    # grafana admin password
#    { name = "grafana.adminPassword", value = random_password.password.result, type = "string" },
#    # grafana dashboard configs
#    { name = "grafana.dashboardproviders.yaml.apiVersion", value = "", type = ""}
#  ]
#}


# deploy open-cost
#module "open-cost" {
#  source           = "../modules/helm_releases"
#  name             = "opencost"
#  chart            = "opencost"
#  chart_version    = "1.10.0"
#  create_namespace = true
#  namespace        = "opencost"
#  repository       = "https://opencost.github.io/opencost-helm-chart"
#  values = [
#    { name = "opencost.ui.enabled", value = "true", type = "string" },
#    { name = "opencost.prometheus.internal.serviceName", value = "kube-prometheus-stack-prometheus", type = "string" },
#    { name = "opencost.prometheus.internal.namespaceName", value = "monitoring", type = "string" }
#  ]
#}

# Application Gateway Subnet
module "appgw_subnet" {
  source               = "../modules/subnets"
  name                 = "${var.name}-appgw"
  address_prefixes     = var.address_prefixes_appgw
  resource_group_name  = module.resouce_group.resource-grp
  service_endpoints    = null
  virtual_network_name = module.virtual_network.vnet
}

# module public ip
module "public_ip" {
  source              = "../modules/public_ip"
  name                = "${var.env}-${var.name}-${var.project}"
  env                 = var.env
  location            = var.location
  project             = var.project
  resource_group_name = module.resouce_group.resource-grp
  allocation_method   = "Static"
}


# deploy application Gateway
module "appgw" {
  source              = "../modules/application_gateway"
  name                = "${var.env}-${var.name}-${var.project}"
  env                 = var.env
  location            = var.location
  project             = var.project
  resource_group_name = module.resouce_group.resource-grp

  sku-name     = "Standard_v2"
  sku-tier     = "Standard_v2"
  sku-capacity = 2

  public_ip_address_id          = module.public_ip.public-id
  private_ip_address            = null
  private_ip_address_allocation = "Dynamic"

  firewall_policy_id = null

  virtual_network_name = module.virtual_network.vnet
  subnet_id            = module.appgw_subnet.subnets-id
}

# user identity
module "uid" {
  source              = "../modules/identity"
  name                = "${var.env}-${var.name}-${var.project}"
  env                 = var.env
  location            = var.location
  project             = var.project
  resource_group_name = module.resouce_group.resource-grp
}

# federated credential
module "fc" {
  source              = "../modules/federated_identity_credential"
  name                = "${var.env}-${var.name}-${var.project}"
  resource_group_name = module.resouce_group.resource-grp
#  uid                 = local.ingress_application_gateway_identity[0][0].client_id
  uid                 = module.uid.uai_id
  audience            = "api://AzureADTokenExchange"
  issuer              = module.kubernetes_service.aks-cluster_oidc_url
  subject             = "system:serviceaccount:kube-system:agic-sa-ingress-azure"
}

# Application Gateway Role Assignment
module "agic-ra-read" {
  source               = "../modules/role_assignment"
  principal_id         = module.uid.uai_principal_id
  role_definition_name = "Reader"
  scope                = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${module.resouce_group.resource-grp}"
}

module "agic-ra-nw" {
  source               = "../modules/role_assignment"
  principal_id         = module.uid.uai_principal_id
  role_definition_name = "Network Contributor"
  scope                = module.virtual_network.vnet-id
}

module "agic-ra-contributor" {
  source               = "../modules/role_assignment"
  principal_id         = module.uid.uai_principal_id
  role_definition_name = "Contributor"
  scope                = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${module.resouce_group.resource-grp}/providers/Microsoft.Network/applicationGateways/${module.appgw.appgw}"
}