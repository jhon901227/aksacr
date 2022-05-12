output "subnetid" {
  value = azurerm_subnet.subent1.id
}
output "subnetname" {
  value = azurerm_subnet.subent1.name
}

output "subne0tname" {
  value = azurerm_subnet.subent0.name
}


output "subnetidLoadBalancer" {
  value = azurerm_subnet.subentloadbalancer.name
}

output "subnetidLoadBalancerid" {
  value = azurerm_subnet.subentloadbalancer.id
}
