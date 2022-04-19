resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.rgname
  location            = var.rglocation_name
  sku                 = var.acr_sku
  admin_enabled       = false
  georeplications {
    location                = "East US"
    zone_redundancy_enabled = true
    tags                    = {}
  }
  georeplications {
    location                = "westeurope"
    zone_redundancy_enabled = true
    tags                    = {}
  }
}