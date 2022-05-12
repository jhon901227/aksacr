resource "azurerm_user_assigned_identity" "aksidentity" {
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  name = "search-api"
}

resource "azurerm_role_assignment" "ingress-contributor" {
  scope = azurerm_user_assigned_identity.aksidentity.id
  role_definition_name = "Managed Identity Operator"
  principal_id = var.object_id
  depends_on = [
    azurerm_user_assigned_identity.aksidentity
  ]
  
}

resource "azurerm_role_assignment" "resource-group-reader" {
  scope = var.rgname
  role_definition_name = "Reader"
  principal_id = azurerm_user_assigned_identity.aksidentity.id
  
  
}
