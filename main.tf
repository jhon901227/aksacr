module "base" {
  source="./Modules/Base"  
  rgname=var.rgname
  rglocation_name=var.rglocation_name
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

module "aks" {
    source = "./Modules/AKS"
    rgname=var.rgname
    rglocation_name=var.rglocation_name
    aksname=var.aksname
    dns_prefix=var.dns_prefix
    tagsaks=var.tagsaks
    depends_on=[module.acr]
}