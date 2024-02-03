locals {
  backend_address_pool_name      = "${var.name}-beap"
  frontend_port_name             = "${var.name}-feport"
  frontend_ip_configuration_name = "${var.name}-feip"
  http_setting_name              = "${var.name}-be-htst"
  listener_name                  = "${var.name}-httplstn"
  request_routing_rule_name      = "${var.name}-rqrt"
  redirect_configuration_name    = "${var.name}-rdrcfg"
}

resource "azurerm_application_gateway" "network" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = var.sku-name
    tier     = var.sku-tier
    capacity = var.sku-capacity
  }

  gateway_ip_configuration {
    name      = "${var.name}-ip-configuration"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                          = local.frontend_ip_configuration_name
    public_ip_address_id          = var.public_ip_address_id
    private_ip_address_allocation = var.private_ip_address_allocation
    private_ip_address            = var.private_ip_address
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 1
  }

  firewall_policy_id = var.firewall_policy_id

  tags = {
    name        = var.name
    project     = var.project
    Location    = var.location
    environment = var.env
  }

  lifecycle {
    ignore_changes = [backend_address_pool, backend_http_settings, http_listener, request_routing_rule, probe, tags]
  }

}