resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource-grp
  dns_prefix          = var.name

  private_cluster_enabled = var.private_cluster_enabled

  azure_policy_enabled = var.azure_policy_enabled

#  microsoft_defender {
#    log_analytics_workspace_id = ""
#  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  local_account_disabled = var.local_account_disabled

  oidc_issuer_enabled = var.oidc_issuer_enabled
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
    enable_auto_scaling = true
    max_count           = 3
    min_count           = 1
    os_disk_size_gb     = 30
    type                = "VirtualMachineScaleSets"
    vnet_subnet_id      = var.vnet_subnet_id
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
      type = "SystemAssigned"
    }

  tags = {
    name        = var.name
    project     = var.project
    Location    = var.location
    environment = var.env
  }

  lifecycle {
    ignore_changes = [tags,azure_policy_enabled]
  }

}