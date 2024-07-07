resource "azurerm_kubernetes_cluster_node_pool" "nodepool" {
  name                   = var.name
  kubernetes_cluster_id  = var.kubernetes_cluster_id
  vm_size                = var.vm_size
  node_count             = var.node_count
  max_count              = var.max_count
  min_count              = var.min_count
  enable_auto_scaling    = true
  enable_host_encryption = false
  fips_enabled           = false
  vnet_subnet_id         = var.vnet_subnet_id
  priority               = var.use_spot == true ? "Spot" : "Regular"
  eviction_policy        = var.use_spot == true ? "Delete" : null
  spot_max_price         = var.use_spot == true ? var.spot_max_price : null


  node_labels = {
    Name = var.name
  }

  tags = {
    name        = var.name
    project     = var.project
    Location    = var.location
    environment = var.env
  }
  lifecycle {
    ignore_changes = [node_taints, tags,node_count]
  }
}