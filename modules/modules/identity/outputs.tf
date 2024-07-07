output "uai_id" {
  value = azurerm_user_assigned_identity.uid.id
}

output "uai_client_id" {
  value = azurerm_user_assigned_identity.uid.client_id
}

output "uai_principal_id" {
  value = azurerm_user_assigned_identity.uid.principal_id
}