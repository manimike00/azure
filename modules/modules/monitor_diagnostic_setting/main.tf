resource "azurerm_monitor_diagnostic_setting" "monitor_diagnostic_setting" {
  name               = var.name
  target_resource_id = var.target_resource_id
  storage_account_id = var.storage_account_id
  enabled_log {
    category_group = "allLogs"
#    retention_policy {
#      enabled = true
#      days = 3
#    }
  }
  metric {
    category = "AllMetrics"
#    retention_policy {
#      enabled = true
#      days = 3
#    }
    enabled = true
  }
}