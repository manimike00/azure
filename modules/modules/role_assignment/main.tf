resource "azurerm_role_assignment" "ra" {
  role_definition_name = var.role_definition_name
  principal_id         = var.principal_id
  scope                = var.scope
  skip_service_principal_aad_check = var.skip_service_principal_aad_check
}
