output "storage_account" {
  value = azurerm_storage_account.azsa.name
}

output "storage_account_id" {
  value = azurerm_storage_account.azsa.id
}

output "storage_account_primary_access_key" {
  value = azurerm_storage_account.azsa.primary_access_key
}