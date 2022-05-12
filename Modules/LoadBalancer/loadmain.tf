resource "azurerm_public_ip" "publiciplb" {
  name                = "PublicIPForLB"
  location            = var.rglocation_name
  resource_group_name = var.rgname
  allocation_method   = "Static"
  sku = "Standard"
}

resource "azurerm_application_gateway" "ingress" {
  name                = "ingress-appgateway"
  resource_group_name = var.rgname
  location            = var.rglocation_name

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = var.subnetlbid
  }

  frontend_port {
    name = "80_port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "publicIP"
    public_ip_address_id = azurerm_public_ip.publiciplb.id
  }

  backend_address_pool {
    name = "aks_backend"
  }

  backend_http_settings {
    name                  = "app-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = "listener_80_port"
    frontend_ip_configuration_name = "publicIP"
    frontend_port_name             = "80_port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "request_routing_rule"
    rule_type                  = "Basic"
    http_listener_name         = "listener_80_port"
    backend_address_pool_name  = "aks_backend"
    backend_http_settings_name = "app-http-settings"
  }
}
/* lets encrypt


resource "azurerm_role_assignment" "ingress-contributor" {
  scope = azurerm_application_gateway.ingress.id
  role_definition_name = "contributor"
  principal_id = "f3ddb6ff-2345-476f-af7e-3a2640c02be0"
  depends_on = [
    azurerm_application_gateway.ingress
  ]
  
}*/