/////////////////////////////////////////////////////////////
// Virtual Networks
/////////////////////////////////////////////////////////////

resource "azurerm_virtual_network" "example_ten_one" {
  name                = "vnet-ten-one"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "example_ten_one" {
  name                 = "virtual-machine-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.example_ten_one.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_virtual_network" "bastion_vnet_example" {
  name                = "bastion-vnet-example"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.2.0.0/16"]
}

resource "azurerm_virtual_network" "example_ten_three" {
  name                = "vnet-ten-three"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.3.0.0/16"]
}

resource "azurerm_subnet" "example_ten_three" {
  name                 = "virtual-machine-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.example_ten_three.name
  address_prefixes     = ["10.3.0.0/24"]
}


/////////////////////////////////////////////////////////////
// Peerings
/////////////////////////////////////////////////////////////

resource "azurerm_virtual_network_peering" "peer-1-to-bastion" {
  name                      = "peer1tobastion"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.example_ten_one.name
  remote_virtual_network_id = azurerm_virtual_network.bastion_vnet_example.id
}

resource "azurerm_virtual_network_peering" "peer-bastion-to-1" {
  name                      = "peerbastionto1"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.bastion_vnet_example.name
  remote_virtual_network_id = azurerm_virtual_network.example_ten_one.id
}

resource "azurerm_virtual_network_peering" "peer-3-to-bastion" {
  name                      = "peer3tobastion"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.example_ten_three.name
  remote_virtual_network_id = azurerm_virtual_network.bastion_vnet_example.id
}

resource "azurerm_virtual_network_peering" "peer-bastion-to-3" {
  name                      = "peerbastionto3"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.bastion_vnet_example.name
  remote_virtual_network_id = azurerm_virtual_network.example_ten_three.id
}

/////////////////////////////////////////////////////////////
// Virtual Machines
/////////////////////////////////////////////////////////////

module "jumpbox_one" {
  source = "git::https://github.com/mason1999/terraform-linux-vm.git?ref=feat/neovim-tmux-init"

  resource_group_name           = var.resource_group_name
  location                      = var.location
  suffix                        = "one"
  subnet_id                     = azurerm_subnet.example_ten_one.id
  enable_public_ip_address      = false
  private_ip_address_allocation = "Static"
  private_ip_address            = "10.1.0.4"
  admin_username                = "testuser"
  admin_password                = "WeakPassword123"
  run_init_script               = false

}

module "jumpbox_two" {
  source = "git::https://github.com/mason1999/terraform-linux-vm.git?ref=feat/neovim-tmux-init"

  resource_group_name           = var.resource_group_name
  location                      = var.location
  suffix                        = "three"
  subnet_id                     = azurerm_subnet.example_ten_three.id
  enable_public_ip_address      = false
  private_ip_address_allocation = "Static"
  private_ip_address            = "10.3.0.4"
  admin_username                = "testuser"
  admin_password                = "WeakPassword123"
  run_init_script               = false

}

/////////////////////////////////////////////////////////////
// Bastion
/////////////////////////////////////////////////////////////

module "bastion_one" {
  source                                = "git::https://github.com/mason1999/terraform-azure-bastion.git"
  name                                  = "bastion-host-one"
  resource_group_name                   = var.resource_group_name
  location                              = var.location
  sku                                   = "Standard"
  virtual_network_id                    = azurerm_virtual_network.bastion_vnet_example.id
  create_azure_bastion_subnet           = true
  azure_bastion_subnet_address_prefixes = ["10.2.0.0/24"]
}
