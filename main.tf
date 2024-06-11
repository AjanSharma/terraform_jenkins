terraform {
 required_providers {
  azurerm = {
   source = "hashicorp/azurerm"
   version = "=3.0.0"
  }
 }
}

provider "azurerm" {
 features {}

 client_id = "${var.client_id}"
 client_secret = "${var.client_secret}"
 tenant_id = "${var.tenant_id}"
 subscription_id = "${var.subscription_id}"
 }

resource "azurerm_resource_group" "rg-terraform" {
 name = "myTFResourceGroup"
 location = var.resource_group_location
 }

resource "azurerm_virtual_network" "vn-terraform" {
 name = "myTFVirtualNetwork"
 address_space = ["10.0.0.0/16"]
 location = azurerm_resource_group.rg-terraform.location
 resource_group_name = azurerm_resource_group.rg-terraform.name
}
resource "azurerm_subnet" "subnet-terraform" {
 name = "myTFSubnet"
 resource_group_name = azurerm_resource_group.rg-terraform.name
 virtual_network_name = azurerm_virtual_network.vn-terraform.name
 address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "ni-terraform" {
 name = "myTFNetworkInterface"
 location = azurerm_resource_group.rg-terraform.location
 resource_group_name = azurerm_resource_group.rg-terraform.name

 ip_configuration {
  name = "internal"
  subnet_id = azurerm_subnet.subnet-terraform.id
  private_ip_address_allocation = "Dynamic"
 }
}

resource "azurerm_virtual_machine" "vm-terraform" {
 name = "myTFVirtualMachine"
 location = azurerm_resource_group.rg-terraform.location
 resource_group_name = azurerm_resource_group.rg-terraform.name
 network_interface_ids = [azurerm_network_interface.ni-terraform.id]
 vm_size = var.vm_size_val

 storage_image_reference {
  publisher = var.publisher_val
  offer = var.offer_val
  sku = var.sku_val
  version = "latest"
 }
 storage_os_disk {
  name = "terraform-disk"
  caching = "ReadWrite"
  create_option = "FromImage"
  managed_disk_type = "Standard_LRS"
 }
 os_profile {
  computer_name = "hostname"
  admin_username = var.admin_username_val
  admin_password = var.admin_password_val
 }
 os_profile_linux_config {
  disable_password_authentication = false
 }
}
