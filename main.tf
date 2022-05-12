
module "base" {
  source          = "./Modules/Base"
  rgname          = var.rgname
  rglocation_name = var.rglocation_name
  acr_secret=var.acr_secret
}

module "acr"{
source="./Modules/ACR"
acr_name=var.acr_name
rgname=var.rgname
rglocation_name=var.rglocation_name
acr_sku=var.acr_sku
depends_on = [
  module.base
]
}

module "vnet" {
  source          = "./Modules/vnet"
  vnetname        = var.vnetname
  rglocation_name = var.rglocation_name
  rgname          = var.rgname
  depends_on = [
    module.base
  ]

}

module "lb" {
  source          = "./Modules/LoadBalancer" 
  subentloadbalancer= module.vnet.subnetidLoadBalancer
  rgname          = var.rgname
  rglocation_name = var.rglocation_name
  subnetlbid=module.vnet.subnetidLoadBalancerid
  depends_on = [
    module.vnet
  ]
}

module "aks" {
  source          = "./Modules/AKS"
  rgname          = var.rgname
  rglocation_name = var.rglocation_name
  aksname         = var.aksname
  dns_prefix      = var.dns_prefix
  tagsaks         = var.tagsaks
  akssubnetname       = module.vnet.subne0tname
  akssubnetid       = module.vnet.subnetid
  lbid = module.lb.lbidout
  subnetlb=module.vnet.subnetidLoadBalancer
  client_secret=var.secret_id
  client_id=var.client_id
  depends_on      = [module.base,module.vnet,module.lb]
}

module "kubectl" {
source = "./Modules/AKS/Kubectl"
depends_on = [
  module.aks
]
  providers = {
  kubectl = kubectl
 }
}


 data "azurerm_kubernetes_cluster" "aks" {
  name                = "aksjohnfinalproject"
  resource_group_name = "aksacr"
}
 provider "kubectl" {
  host                   = data.azurerm_kubernetes_cluster.aks.kube_config.0.host
  username =                 data.azurerm_kubernetes_cluster.aks.kube_config.0.username
  password =                 data.azurerm_kubernetes_cluster.aks.kube_config.0.password
  client_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  load_config_file       = false
}