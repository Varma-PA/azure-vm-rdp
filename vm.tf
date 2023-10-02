# # ## <https://www.terraform.io/docs/providers/azurerm/index.html>
# # provider "azurerm" {
# #   version = "=2.5.0"
# #   features {}
# # }

# ## <https://www.terraform.io/docs/providers/azurerm/r/resource_group.html>
# resource "azurerm_resource_group" "rg" {
#   name     = "TerraformTesting"
#   location = "eastus"
# }

# ## <https://www.terraform.io/docs/providers/azurerm/r/availability_set.html>
# resource "azurerm_availability_set" "DemoAset" {
#   name                = "example-aset"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
# }

# ## <https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html>
# resource "azurerm_virtual_network" "vnet" {
#   name                = "vNet"
#   address_space       = ["10.0.0.0/16"]
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
# }

# ## <https://www.terraform.io/docs/providers/azurerm/r/subnet.html> 
# resource "azurerm_subnet" "subnet" {
#   name                 = "internal"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.0.2.0/24"]
# }

# ## <https://www.terraform.io/docs/providers/azurerm/r/network_interface.html>
# resource "azurerm_network_interface" "example" {
#   name                = "example-nic"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.subnet.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# ## <https://www.terraform.io/docs/providers/azurerm/r/windows_virtual_machine.html>
# resource "azurerm_windows_virtual_machine" "example" {
#   name                = "example-machine"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   size                = "Standard_F2"
#   admin_username      = "adminuser"
#   admin_password      = "P@$$w0rd1234!"
#   availability_set_id = azurerm_availability_set.DemoAset.id
#   network_interface_ids = [
#     azurerm_network_interface.example.id,
#     azurerm_network_interface.public.id
#   ]

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "MicrosoftWindowsServer"
#     offer     = "WindowsServer"
#     sku       = "2016-Datacenter"
#     version   = "latest"
#   }
# }

# resource "azurerm_network_security_group" "example" {
#   name                = "acceptanceTestSecurityGroup1"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
# }

# resource "azurerm_network_security_rule" "outbound" {
#   name                        = "test123"
#   priority                    = 100
#   direction                   = "Outbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.rg.name
#   network_security_group_name = azurerm_network_security_group.example.name
# }

# resource "azurerm_network_security_rule" "inbound" {
#   name                        = "remote"
#   priority                    = 100
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "3389"
#   destination_port_range      = "3389"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.rg.name
#   network_security_group_name = azurerm_network_security_group.example.name
# }

# resource "azurerm_public_ip" "example" {
#   name                = "example-public-ip"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   allocation_method   = "Dynamic"
# }

# resource "azurerm_network_interface" "public" {
#   name                = "example-nic-public"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   enable_ip_forwarding = true

#   ip_configuration {
#     name                          = "public"
#     subnet_id                     = azurerm_subnet.subnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.example.id
#   }
# }

# resource "azurerm_network_security_group" "sg-rdp-connection" {
#   name                = "allowrdpconnection"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   security_rule {
#     name                       = "rdpport"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "3389"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#   tags = {
#     environment = "Testing"
#   }
# }

# resource "azurerm_network_interface_security_group_association" "example" {
#   network_interface_id      = azurerm_network_interface.public.id
#   network_security_group_id = azurerm_network_security_group.sg-rdp-connection.id
# }