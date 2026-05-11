resource "azurerm_static_web_app_custom_domain" "static_web_app_custom_domain" {
  static_web_app_id = var.static_web_app_id
  domain_name       = var.domain_name
  validation_type   = var.validation_type # "dns-txt-token"
}