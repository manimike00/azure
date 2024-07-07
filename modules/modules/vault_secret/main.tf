#resource "azurerm_key_vault_secret" "vs" {
#  name         = var.secret_name
#  value        = var.secret_value
#  key_vault_id = var.key_vault_id
#}

resource "azurerm_key_vault_secret" "vs" {
  count        = length(var.secret_maps)
  name         = keys(var.secret_maps)[count.index]
  value        = values(var.secret_maps)[count.index]
  key_vault_id = var.key_vault_id

}