resource "azurerm_federated_identity_credential" "fic" {
  name                = var.name
  resource_group_name = var.resource_group_name
  audience            = [var.audience]
  issuer              = var.issuer
  parent_id           = var.uid
  subject             = var.subject
}
