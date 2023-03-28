output "vault" {
  value = azurerm_key_vault.akv.name
}

output "vault-uri" {
  value = azurerm_key_vault.akv.vault_uri
}

output "vault-id" {
  value = azurerm_key_vault.akv.id
}