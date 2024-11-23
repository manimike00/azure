module "rg" {
  source   = "../modules/resource_group"
  name     = "${var.name}-${var.project}-rg"
  project  = var.project
  env      = var.env
  location = var.location
}

module "private_dns" {
  source              = "../modules/private_dns_zone"
  name                = "${var.name}-${var.project}-rg"
  project             = var.project
  env                 = var.env
  location            = var.location
  dns_name            = "privatelink.centralindia.azmk8s.io"
  resource_group_name = module.rg.resource-grp
}

module "vnet" {
  source              = "../modules/virtual_network"
  name                = "${var.name}-${var.project}-vnet"
  env                 = var.env
  location            = var.location
  project             = var.project
  resource_group_name = module.rg.resource-grp
  address_space       = "10.100.0.0/16"
}

module "vnet_private_dns_link" {
  source                = "../modules/private_dns_zone_vnet_link"
  name                  = "${var.name}-${var.project}-vnet-link"
  env                   = var.env
  project               = var.project
  location              = var.location
  resource_group_name   = module.rg.resource-grp
  private_dns_zone_name = module.private_dns.private_dns_zone
  virtual_network_id    = module.vnet.vnet-id
}

# userIdentity for shared aks
module "uid_aks" {
  source              = "../modules/identity"
  name                = "${var.env}-${var.project}-aks-uid"
  env                 = var.env
  location            = var.location
  project             = var.project
  resource_group_name = module.rg.resource-grp
}

# role assignment for prod aks
module "uid_aks_ra" {
  source               = "../modules/role_assignment"
  principal_id         = module.uid_aks.uai_principal_id
  role_definition_name = "Private DNS Zone Contributor"
  scope                = module.private_dns.private_dns_zone_id
}

module "uid_aks_vnet_ra" {
  source               = "../modules/role_assignment"
  principal_id         = module.uid_aks.uai_principal_id
  role_definition_name = "Network Contributor"
  scope                = module.vnet.vnet-id
}

# create subnet for default nodepool
module "default_np_subnet" {
  source               = "../modules/subnets"
  name                 = "${var.name}-system-np"
  address_prefixes     = "10.100.0.0/20"
  resource_group_name  = module.rg.resource-grp
  service_endpoints    = null
  virtual_network_name = module.vnet.vnet
}

# create kubernetes service
module "kubernetes_service" {
  depends_on                          = [module.uid_aks_ra]
  source                              = "../modules/kubernetes_service"
  name                                = "${var.name}-${var.project}"
  env                                 = var.env
  project                             = var.project
  location                            = var.location
  default-np-size                     = "Standard_B2ms"
  local_account_disabled              = false
  kubernetes_version                  = "1.29"
  resource-grp                        = module.rg.resource-grp
  vnet_subnet_id                      = module.default_np_subnet.subnets-id
  private_cluster_enabled             = true
  private_cluster_public_fqdn_enabled = false
  private_dns_zone_id                 = module.private_dns.private_dns_zone_id
  identity                            = "UserAssigned"
  identity_ids                        = [module.uid_aks.uai_id]
  oidc_issuer_enabled                 = true
  workload_identity_enabled           = true
  azure_policy_enabled                = false
  sku_tier                            = "Standard"
  cost_analysis_enabled               = true
  network_plugin                      = "azure"
  network_policy                      = "cilium"
  blob_driver_enabled                 = true
  enable_auto_scaling                 = false
  max_count                           = null
  min_count                           = null
  node_count                          = 1
}


module "public_subnet" {
  source               = "../modules/subnets"
  name                 = "${var.name}-${var.project}-public-subnet"
  address_prefixes     = "10.100.49.0/24"
  resource_group_name  = module.rg.resource-grp
  virtual_network_name = module.vnet.vnet
}

# module public ip
module "bastion_public_ip" {
  source              = "../modules/public_ip"
  name                = "${var.name}-${var.project}-bastion-ip"
  env                 = var.env
  location            = var.location
  project             = var.project
  resource_group_name = module.rg.resource-grp
  allocation_method   = "Static"
}
module "nic" {
  source               = "../modules/network_interface"
  name                 = "${var.name}-${var.project}-bastion-ip"
  env                  = var.env
  location             = var.location
  project              = var.project
  public_ip_address_id = module.bastion_public_ip.public-id
  resource_group_name  = module.rg.resource-grp
  subnet_id            = module.public_subnet.subnets-id
}

module "bastion_network_sg" {
  source              = "../modules/network_security_group"
  name                = "${var.name}-${var.project}-bastion-sg"
  env                 = var.env
  location            = var.location
  project             = var.project
  resource_group_name = module.rg.resource-grp
}

locals {
  ngrules = {
    ssh = {
      name                       = "ssh"
      priority                   = 201
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

module "network_sg_rules" {
  source                      = "../modules/network_security_group_rule"
  for_each                    = local.ngrules
  name                        = each.key
  resource_group_name         = module.rg.resource-grp
  direction                   = each.value.direction
  access                      = each.value.access
  priority                    = each.value.priority
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  network_security_group_name = module.bastion_network_sg.network_sg
}

module "bastion_nic_sg_bind" {
  source                    = "../modules/nic_sg_association"
  network_interface_id      = module.nic.nic_id
  network_security_group_id = module.bastion_network_sg.network_sg_id
}

# user identity
module "bastion_uid" {
  source              = "../modules/identity"
  name                = "${var.env}-${var.project}-bastion-uid"
  env                 = var.env
  location            = var.location
  project             = var.project
  resource_group_name = module.rg.resource-grp
}

# AKS Role Assignment
module "bastion_vm_role" {
  source               = "../modules/role_assignment"
  principal_id         = module.bastion_uid.uai_principal_id
  role_definition_name = "Owner"
  scope                = module.rg.resource-id
}

module "bastion_vm_role_aks" {
 source               = "../modules/role_assignment"
 principal_id         = module.bastion_uid.uai_principal_id
 role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
 scope                = module.kubernetes_service.aks-id
}

module "bastion" {
  source                = "../modules/virtual_machine"
  name                  = "${var.env}-${var.project}-bastion"
  env                   = var.env
  project               = var.project
  location              = var.location
  resource_group_name   = module.rg.resource-grp
  admin_username        = "basadmin"
  public_key            = ""
  network_interface_ids = [module.nic.nic_id]
  size                  = "Standard_B1ms"
  identity              = "UserAssigned"
  identity_ids          = [module.bastion_uid.uai_id]
  custom_data           = file("${path.module}/customdata/data.sh")
}

# # create subnets nodepool
# module "nodepool_subnets" {
#  source               = "../modules/subnets"
#  name                 = "${var.env}-${var.name}-${var.project}"
#  address_prefixes     = var.address_prefixes_monitoring_np
#  resource_group_name  = module.resouce_group.resource-grp
#  service_endpoints    = null
#  virtual_network_name = module.virtual_network.vnet
# }

# # create user node pool
# module "monitoring" {
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
# }

# # create stoage account
# module "storage_account" {
#  source                   = "../modules/storage_account"
#  name                     = "${var.env}${var.name}${var.project}backup"
#  env                      = var.env
#  location                 = var.location
#  project                  = var.project
#  resource_group_name      = module.resouce_group.resource-grp
#  account_tier             = "Standard"
#  account_replication_type = "GRS"
# }

# ### create storage container
# module "storage_container" {
#  source                = "../modules/storage_container"
#  name                  = "velero"
#  storage_account_name  = module.storage_account.storage_account
#  container_access_type = "private"
# }

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

## deploy velero
##module "velero" {
##  source           = "../modules/helm_releases"
##  name             = "velero"
##  chart            = "velero"
##  create_namespace = true
##  namespace        = "velero"
##  chart_version    = "3.1.3"
##  repository       = "https://vmware-tanzu.github.io/helm-charts"
##  values = [
##    { name = "initContainers[0].name", value = "velero-plugin-for-azure", type = "string" },
##    { name = "initContainers[0].image", value = "velero/velero-plugin-for-microsoft-azure:v1.5.0", type = "string" },
##    { name = "initContainers[0].imagePullPolicy", value = "IfNotPresent", type = "string" },
##    { name = "initContainers[0].volumeMounts[0].mountPath", value = "/target", type = "string" },
##    { name = "initContainers[0].volumeMounts[0].name", value = "plugins", type = "string" },
##    { name = "credentials.secretContents.cloud", value = local.azure_creds, type = "string" },
##    { name = "configuration.provider", value = "azure", type = "string" },
##    { name = "configuration.backupStorageLocation.bucket", value = module.storage_container.storage_container, type = "string" },
##    { name = "configuration.backupStorageLocation.config.resourceGroup", value = module.resouce_group.resource-grp, type = "string" },
##    { name = "configuration.backupStorageLocation.config.storageAccount", value = module.storage_account.storage_account, type = "string" },
##    { name = "configuration.backupStorageLocation.config.subscriptionId", value = var.subscription_id, type = "string" },
##    { name = "configuration.backupStorageLocation.default", value = "true", type = "string" }
##  ]
##}
#
## random password
##resource "random_password" "password" {
##  length           = 16
##  special          = true
##  override_special = "!#$%&*()-_=+[]{}<>:?"
##}
#
## deploy kube-prometheus-stack
##module "kube-prometheus-stack" {
##  source           = "../modules/helm_releases"
##  name             = "kube-prometheus-stack"
##  chart            = "kube-prometheus-stack"
##  chart_version    = "45.8.1"
##  create_namespace = true
##  namespace        = "monitoring"
##  repository       = "https://prometheus-community.github.io/helm-charts"
##  values = [
##    # scrape configs for opencost
##    { name = "prometheus.prometheusSpec.additionalScrapeConfigs[0].job_name", value = "opencost", type = "string"},
##    { name = "prometheus.prometheusSpec.additionalScrapeConfigs[0].scrape_interval", value = "1m", type = "string"},
##    { name = "prometheus.prometheusSpec.additionalScrapeConfigs[0].scrape_timeout", value = "10s", type = "string"},
##    { name = "prometheus.prometheusSpec.additionalScrapeConfigs[0].metrics_path", value = "/metrics", type = "string"},
##    { name = "prometheus.prometheusSpec.additionalScrapeConfigs[0].scheme", value = "http", type = "string"},
##    { name = "prometheus.prometheusSpec.additionalScrapeConfigs[0].static_configs[0].targets[0]", value = "opencost.opencost.svc.cluster.local:9003", type = "string"},
##    # scrape configs for velero
##    { name = "prometheus.prometheusSpec.additionalScrapeConfigs[1].job_name", value = "velero", type = "string"},
##    { name = "prometheus.prometheusSpec.additionalScrapeConfigs[1].scrape_interval", value = "30s", type = "string"},
##    { name = "prometheus.prometheusSpec.additionalScrapeConfigs[1].scrape_timeout", value = "10s", type = "string"},
##    { name = "prometheus.prometheusSpec.additionalScrapeConfigs[1].metrics_path", value = "/metrics", type = "string"},
##    { name = "prometheus.prometheusSpec.additionalScrapeConfigs[1].scheme", value = "http", type = "string"},
##    { name = "prometheus.prometheusSpec.additionalScrapeConfigs[1].static_configs[0].targets[0]", value = "velero.velero.svc.cluster.local:8085", type = "string"},
##    # grafana admin password
##    { name = "grafana.adminPassword", value = random_password.password.result, type = "string" },
##    # grafana dashboard configs
##    { name = "grafana.dashboardproviders.yaml.apiVersion", value = "", type = ""}
##  ]
##}
#
#
## deploy open-cost
##module "open-cost" {
##  source           = "../modules/helm_releases"
##  name             = "opencost"
##  chart            = "opencost"
##  chart_version    = "1.10.0"
##  create_namespace = true
##  namespace        = "opencost"
##  repository       = "https://opencost.github.io/opencost-helm-chart"
##  values = [
##    { name = "opencost.ui.enabled", value = "true", type = "string" },
##    { name = "opencost.prometheus.internal.serviceName", value = "kube-prometheus-stack-prometheus", type = "string" },
##    { name = "opencost.prometheus.internal.namespaceName", value = "monitoring", type = "string" }
##  ]
##}
#
### Application Gateway Subnet
#module "appgw_subnet" {
#  source               = "../modules/subnets"
#  name                 = "appgwsub"
#  address_prefixes     = "10.15.16.0/24"
#  resource_group_name  = azurerm_resource_group.example.name
#  service_endpoints    = null
#  virtual_network_name = azurerm_virtual_network.example.name
#}
#
### module public ip
#module "public_ip" {
#  source              = "../modules/public_ip"
#  name                = "appgw-ip"
#  env                 = "test"
#  location            = "centralindia"
#  project             = "example"
#  resource_group_name = azurerm_resource_group.example.name
#  allocation_method   = "Static"
#}
##
##
### deploy application Gateway
#module "appgw" {
#  source              = "../modules/application_gateway"
#  name                = "exampleagggw"
#  env                 = "test"
#  location            = "centralindia"
#  project             = "example"
#  resource_group_name = azurerm_resource_group.example.name
#
#  sku-name     = "Standard_v2"
#  sku-tier     = "Standard_v2"
#  sku-capacity = 2
#
#  public_ip_address_id          = module.public_ip.public-id
#  private_ip_address            = null
#  private_ip_address_allocation = "Dynamic"
#
#  firewall_policy_id = null
#
#  virtual_network_name = azurerm_virtual_network.example.name
#  subnet_id            = module.appgw_subnet.subnets-id
#}
##
#### user identity
#module "appgw_uid" {
#  source              = "../modules/identity"
#  name                = "test-exmaple-appgw"
#  env                 = "test"
#  location            = "centralindia"
#  project             = "example"
#  resource_group_name = azurerm_resource_group.example.name
#}
#
#module "karpentermsi_uid" {
#  source              = "../modules/identity"
#  name                = "karpentermsi"
#  env                 = "test"
#  location            = "centralindia"
#  project             = "example"
#  resource_group_name = azurerm_resource_group.example.name
#}

## federated credential
#module "fc" {
#  source              = "../modules/federated_identity_credential"
#  name                = "test"
#  resource_group_name = azurerm_resource_group.example.name
#  uid                 = module.appgw_uid.uai_id
#  audience            = "api://AzureADTokenExchange"
#  issuer              = azurerm_kubernetes_cluster.example.oidc_issuer_url
#  subject             = "system:serviceaccount:kube-system:agic-sa-ingress-azure"
#}
#
#module "karpenter_fc" {
#  source              = "../modules/federated_identity_credential"
#  name                = "kp_test"
#  resource_group_name = azurerm_resource_group.example.name
#  uid                 = module.karpentermsi_uid.uai_id
#  audience            = "api://AzureADTokenExchange"
#  issuer              = azurerm_kubernetes_cluster.example.oidc_issuer_url
#  subject             = "system:serviceaccount:kube-system:karpenter-sa"
#}

## Application Gateway Role Assignment
#module "agic-ra-read" {
#  source               = "../modules/role_assignment"
#  principal_id         = module.appgw_uid.uai_principal_id
#  role_definition_name = "Reader"
#  scope                = azurerm_resource_group.example.id
#}
#
#module "agic-ra-nw" {
#  source               = "../modules/role_assignment"
#  principal_id         = module.appgw_uid.uai_principal_id
#  role_definition_name = "Network Contributor"
#  scope                = azurerm_virtual_network.example.id
#}
#
#module "agic-ra-contributor" {
#  source               = "../modules/role_assignment"
#  principal_id         = module.appgw_uid.uai_principal_id
#  role_definition_name = "Contributor"
#  scope                = module.appgw.appgw-id
#}

locals {
  kp_roles = [
    "Virtual Machine Contributor",
    "Network Contributor",
    "Managed Identity Operator"
  ]
}

#module "kp_uid_roles" {
#  count = length(local.kp_roles)
#  source               = "../modules/role_assignment"
#  principal_id         = module.appgw_uid.uai_principal_id
#  role_definition_name = local.kp_roles[count.index]
#  scope                = azurerm_kubernetes_cluster.example.node_resource_group_id
#}

#module "kp_vnet" {
#  source               = "../modules/role_assignment"
#  principal_id         = module.karpentermsi_uid.uai_principal_id
#  role_definition_name = "Virtual Machine Contributor"
#  scope                = azurerm_kubernetes_cluster.example.node_resource_group_id
#}
#
#module "kp_vnet_id" {
#  source               = "../modules/role_assignment"
#  principal_id         = module.karpentermsi_uid.uai_principal_id
#  role_definition_name = "Network Contributor"
#  scope                = azurerm_virtual_network.example.id
#}
#
#module "kp_rg" {
#  source               = "../modules/role_assignment"
#  principal_id         = module.karpentermsi_uid.uai_principal_id
#  role_definition_name = "Contributor"
#  scope                = azurerm_kubernetes_cluster.example.node_resource_group_id
#}

##locals {
##  roles = ["Virtual Machine Contributor","Network Contributor"]
##}
##
##module "karpenter-ra-contributor" {
##  count                = length(local.roles)
##  source               = "../modules/role_assignment"
##  principal_id         = module.karpenter_uid.uai_principal_id
##  role_definition_name = local.roles[count.index]
##  scope                = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${module.kubernetes_service.node_resource_group}"
##}
#
### deploy agic - agic-sa-ingress-azure
##module "agic" {
##  source           = "../modules/helm_releases"
##  name             = "agic"
##  chart            = "ingress-azure"
##  chart_version    = "1.7.2"
##  create_namespace = false
##  namespace        = "kube-system"
##  repository       = "https://appgwingress.blob.core.windows.net/ingress-azure-helm-package"
##  values = [
##    { name = "appgw.environment", value = "AZUREPUBLICCLOUD", type = "string" },
##    { name = "appgw.subscriptionId", value = data.azurerm_subscription.current.id, type = "string" },
##    { name = "appgw.resourceGroup", value = module.resouce_group.resource-grp, type = "string" },
##    { name = "appgw.name", value = module.appgw.appgw, type = "string" },
##    { name = "armAuth.type", value = "workloadIdentity", type = "string" },
##    { name = "armAuth.identityClientID", value = module.uid.uai_client_id, type = "string" },
##    { name = "rbac.enabled", value = "true", type = "string"}
##  ]
##}
#
#
### user identity
##module "blob_driver_uid" {
##  source              = "../modules/identity"
##  name                = "${var.env}-${var.name}-${var.project}-blob-driver"
##  env                 = var.env
##  location            = var.location
##  project             = var.project
##  resource_group_name = module.resouce_group.resource-grp
##}
##
##
### federated credential
##module "blob_driver_fc" {
##  source              = "../modules/federated_identity_credential"
##  name                = "${var.env}-${var.name}-${var.project}-blob-driver"
##  resource_group_name = module.resouce_group.resource-grp
##  uid                 = module.blob_driver_uid.uai_id
##  audience            = "api://AzureADTokenExchange"
##  issuer              = "https://eastus.oic.prod-aks.azure.com/ae154255-ea98-40bb-99ca-a8464d43c627/c899988e-2485-4ea1-b32a-1e940296b8f8/"
##  subject             = "system:serviceaccount:kube-system:core-k8s-tools-sa-blob-csi-driver"
##}
#
### deploy loki-distributed - loki-distributed
##module "loki-distributed" {
##  source           = "../modules/helm_releases"
##  name             = "loki-distributed"
##  chart            = "loki-distributed"
##  chart_version    = "0.79.0"
##  create_namespace = false
##  namespace        = "monitoring"
##  repository       = "https://grafana.github.io/helm-charts"
##  values-yaml      = tolist([jsonencode(yamldecode(file("${path.module}/helm-values/loki-distributed.yaml")))])
##}
