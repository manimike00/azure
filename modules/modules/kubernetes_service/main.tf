resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource-grp
  dns_prefix          = var.name
  kubernetes_version  = var.kubernetes_version

  sku_tier                            = var.sku_tier
  cost_analysis_enabled               = var.cost_analysis_enabled
  private_cluster_enabled             = var.private_cluster_enabled
  private_cluster_public_fqdn_enabled = var.private_cluster_public_fqdn_enabled
  private_dns_zone_id                 = var.private_dns_zone_id

  azure_policy_enabled = var.azure_policy_enabled

  #  microsoft_defender {
  #    log_analytics_workspace_id = ""
  #  }

  storage_profile {
    blob_driver_enabled = var.blob_driver_enabled
  }

  network_profile {
    network_plugin      = var.network_plugin
    network_policy      = var.network_policy
    network_data_plane  = var.network_policy == "cilium" ? "cilium" : null
    network_plugin_mode = var.network_policy == "cilium" ? "overlay" : null
    #    pod_cidr = "192.168.0.0/16"
  }

  local_account_disabled = var.local_account_disabled

  oidc_issuer_enabled       = var.oidc_issuer_enabled
  workload_identity_enabled = var.workload_identity_enabled

  #  role_based_access_control_enabled = true
  #
  #  azure_active_directory_role_based_access_control {
  #    managed                = true
  #    tenant_id              = var.tenant_id
  #    admin_group_object_ids = var.admin_group_object_ids
  #    azure_rbac_enabled     = true
  #  }

  default_node_pool {
    name    = "systempool"
    vm_size = var.default-np-size
    #    orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
    #    availability_zones   = [1, 2, 3]
    enable_auto_scaling = var.enable_auto_scaling
    max_count           = var.max_count
    min_count           = var.min_count
    node_count          = var.node_count
    os_disk_size_gb     = 30
    type                = "VirtualMachineScaleSets"
    vnet_subnet_id      = var.vnet_subnet_id
    upgrade_settings {
      max_surge = "10%"
    }
    node_labels = {
      "name"          = var.name
      "nodepool-type" = "system"
      "environment"   = var.env
      "nodepoolos"    = "linux"
      "app"           = "system-apps"
    }
    tags = {
      "name"          = var.name
      "nodepool-type" = "system"
      "environment"   = var.env
      "nodepoolos"    = "linux"
      "app"           = "system-apps"
    }
  }

  #    ingress_application_gateway {
  #      gateway_id = var.gateway_id
  #    }

  #    service_principal {
  #      client_id     = var.client_id
  #      client_secret = var.client_secret
  #    }

  identity {
    type         = var.identity
    identity_ids = var.identity == "SystemAssigned" ? null : var.identity_ids
  }

  tags = {
    name        = var.name
    project     = var.project
    Location    = var.location
    environment = var.env
  }

  lifecycle {
    ignore_changes = [tags, azure_policy_enabled]
  }

}