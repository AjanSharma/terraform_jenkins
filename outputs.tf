output "resource_group_name" {
  value = azurerm_resource_group.rg-terraform.name
}

output "network_interface_name" {
  value = azurerm_network_interface.ni-terraform.name
}
