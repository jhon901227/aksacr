resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aksname
  location            = var.rglocation_name
  resource_group_name = var.rgname
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
    vnet_subnet_id = var.akssubnetid
    os_sku = "Ubuntu"
  }

 service_principal {
   client_id = var.client_id
   client_secret = var.client_secret
 }

  network_profile {
    network_plugin="azure"
  }

  aci_connector_linux {
    subnet_name = var.akssubnetname
  }

  ingress_application_gateway {
  gateway_id = var.lbid

  
  }

  tags = {
    Environment = "Production"
  }
}


