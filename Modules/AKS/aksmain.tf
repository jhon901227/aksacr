resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aksname
  location            = var.rglocation_name
  resource_group_name = var.rgname
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

