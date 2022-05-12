resource "azurerm_virtual_network" "vnetjohn" {
  name                = var.vnetname
  location            = var.rglocation_name
  resource_group_name = var.rgname
  address_space       = ["172.16.0.0/16"]
 tags = {
    environment = "Production"
  }
}
resource "azurerm_subnet" "subent0" {
  name                 = "subent0"
  virtual_network_name = azurerm_virtual_network.vnetjohn.name
  resource_group_name  = var.rgname
  address_prefixes     = ["172.16.0.0/24"]
  depends_on = [
    azurerm_virtual_network.vnetjohn
  ]
  
  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }


}



resource "azurerm_subnet" "subent1" {
  name                 = "subent1"
  virtual_network_name = azurerm_virtual_network.vnetjohn.name
  resource_group_name  = var.rgname
  address_prefixes     = ["172.16.1.0/24"]
  depends_on = [
    azurerm_virtual_network.vnetjohn
  ]
   
}


resource "azurerm_virtual_network" "vnetloadbalancer" {
  name                = "vnetloadbalancer"
  location            = var.rglocation_name
  resource_group_name = var.rgname
  address_space       = ["172.17.0.0/16"]
 tags = {
    environment = "Production"
  }
}

resource "azurerm_subnet" "subentloadbalancer" {
  name                 = "subentloadbalancer"
  virtual_network_name = azurerm_virtual_network.vnetloadbalancer.name
  resource_group_name  = var.rgname
  address_prefixes     = ["172.17.1.0/24"]
  depends_on = [
    azurerm_virtual_network.vnetloadbalancer
  ]
}


resource "azurerm_virtual_network_peering" "vnet1" {
  name                      = "peer1to2"
  resource_group_name       = var.rgname
  virtual_network_name      = azurerm_virtual_network.vnetjohn.name
  remote_virtual_network_id = azurerm_virtual_network.vnetloadbalancer.id
}

resource "azurerm_virtual_network_peering" "vnet2" {
  name                      = "peer2to1"
  resource_group_name       = var.rgname
  virtual_network_name      = azurerm_virtual_network.vnetloadbalancer.name
  remote_virtual_network_id = azurerm_virtual_network.vnetjohn.id
}