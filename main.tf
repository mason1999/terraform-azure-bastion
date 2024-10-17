resource "azurerm_public_ip" "this" {
  count               = var.sku != "Developer" ? 1 : 0
  name                = "${var.name}-public-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = var.sku
  tags                = var.tags
}

resource "azurerm_subnet" "this" {
  count                = var.sku != "Developer" && var.create_azure_bastion_subnet == true ? 1 : 0
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = local.virtual_network_name
  address_prefixes     = var.azure_bastion_subnet_address_prefixes
}

resource "azurerm_network_security_group" "this" {
  count               = var.sku != "Developer" && var.create_azure_bastion_subnet == true ? 1 : 0
  name                = "AzureBastionSubnetNSG"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowHttpsInbound"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "Internet"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "443"
  }

  security_rule {
    name                       = "AllowGatewayMangerInbound"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "GatewayManager"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "443"
  }

  security_rule {
    name                       = "AllowAzureLoadBalancerInbound"
    priority                   = 140
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "AzureLoadBalancer"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "443"
  }

  security_rule {
    name                       = "AllowBastionHostCommunication"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
    destination_address_prefix = "VirtualNetwork"
    destination_port_ranges    = ["8080", "5071"]
  }

}
resource "azurerm_subnet_network_security_group_association" "this" {
  count                     = var.sku != "Developer" && var.create_azure_bastion_subnet == true ? 1 : 0
  subnet_id                 = azurerm_subnet.this[0].id
  network_security_group_id = azurerm_network_security_group.this[0].id
}

resource "azurerm_bastion_host" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  scale_units         = var.scale_units

  dynamic "ip_configuration" {
    for_each = var.sku != "Developer" ? [1] : []
    content {
      name                 = "${var.name}-ip-configuration"
      subnet_id            = var.sku != "Developer" && var.create_azure_bastion_subnet == true ? azurerm_subnet.this[0].id : var.azure_bastion_subnet_id
      public_ip_address_id = azurerm_public_ip.this[0].id
    }
  }

  copy_paste_enabled     = var.copy_paste_enabled
  file_copy_enabled      = var.file_copy_enabled
  ip_connect_enabled     = var.ip_connect_enabled
  kerberos_enabled       = var.kerberos_enabled
  shareable_link_enabled = var.shareable_link_enabled
  tunneling_enabled      = var.tunneling_enabled
  virtual_network_id     = var.virtual_network_id
  tags                   = var.tags
}
