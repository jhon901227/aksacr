resource "azurerm_resource_group" "rgAksAcr" {
  name     = var.rgname
  location = var.rglocation_name
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  name                        = "aksacrkeyvault3"
  location                    = var.rglocation_name
  resource_group_name         = var.rgname
  enabled_for_disk_encryption = true
  tenant_id                   = "c160a942-c869-429f-8a96-f8c8296d57db"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "premium"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      
      "Create",
     
    ]

    secret_permissions = [
     
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover",
      "List"
      
    ]

    storage_permissions = [
      
      "Get",
     
    ]
  }
}

resource "azurerm_key_vault_secret" "example" {
  name         = "acr"
  value        = var.acr_secret
  key_vault_id = azurerm_key_vault.keyvault.id
}