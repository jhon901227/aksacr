resource "azurerm_resource_group" "rgAksAcr" {
  name     = var.rgname
  location = var.rglocation_name
}