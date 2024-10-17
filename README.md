<!-- BEGIN_TF_DOCS -->

# Azure Bastion

Azure Bastion is a fully managed service by Microsoft Azure that provides secure and seamless RDP (Remote Desktop Protocol) and SSH (Secure Shell) access to your virtual machines (VMs) directly from the Azure portal without needing to expose your VMs to public internet.

# Overview

## Features

- Pubilc IP will be deployed alongside the Bastion
- Traffic is secured via SSL/TLS
- Can connect to VM's over SSH / RDP

## Limitations

- List any limitations of the module here

## Documentation

- Design architecture: https://learn.microsoft.com/en-us/azure/bastion/design-architecture
- SKU's comparison: https://learn.microsoft.com/en-us/azure/bastion/configuration-settings
- Interaction between Bastion and VM: https://learn.microsoft.com/en-us/azure/bastion/vm-about
- Vnet peering and Bastion: https://learn.microsoft.com/en-us/azure/bastion/vnet-peering
- Network Security Groups: https://learn.microsoft.com/en-us/azure/bastion/bastion-nsg

# Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.5.0 |

# Resources

| Name | Type |
|------|------|
| [azurerm_bastion_host.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host) | resource |
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |

# Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. Review Azure Bastion Host FAQ for supported locations. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Specifies the name of the Bastion Host. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Bastion Host. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_azure_bastion_subnet_address_prefixes"></a> [azure\_bastion\_subnet\_address\_prefixes](#input\_azure\_bastion\_subnet\_address\_prefixes) | (Optional) Address prefixes for azure bastion subnet to be created. Required when create\_azure\_bastion\_subnet is set to true. | `list(string)` | `[]` | no |
| <a name="input_azure_bastion_subnet_id"></a> [azure\_bastion\_subnet\_id](#input\_azure\_bastion\_subnet\_id) | (Optional) A subnet which has at least a size of /26 which is named AzureBastionSubnet. Required if create\_azure\_bastion\_subnet is false. | `string` | `null` | no |
| <a name="input_copy_paste_enabled"></a> [copy\_paste\_enabled](#input\_copy\_paste\_enabled) | (Optional) Is Copy/Paste feature enabled for the Bastion Host. Defaults to true. | `bool` | `true` | no |
| <a name="input_create_azure_bastion_subnet"></a> [create\_azure\_bastion\_subnet](#input\_create\_azure\_bastion\_subnet) | (Optional) Boolean flag to create the azure bastion subnet and associate network security rules. Defaults to false. | `bool` | `false` | no |
| <a name="input_file_copy_enabled"></a> [file\_copy\_enabled](#input\_file\_copy\_enabled) | (Optional) Is File Copy feature enabled for the Bastion Host. Defaults to false.<br><br>  Note: file\_copy\_enabled is only supported when sku is Standard. | `bool` | `false` | no |
| <a name="input_ip_connect_enabled"></a> [ip\_connect\_enabled](#input\_ip\_connect\_enabled) | (Optional) Is IP Connect feature enabled for the Bastion Host. Defaults to false.<br><br>  Note: ip\_connect\_enabled is only supported when sku is Standard. | `bool` | `false` | no |
| <a name="input_kerberos_enabled"></a> [kerberos\_enabled](#input\_kerberos\_enabled) | (Optional) Is Kerberos authentication feature enabled for the Bastion Host. Defaults to false.<br><br>  Note: kerberos\_enabled is only supported when sku is Standard. | `bool` | `false` | no |
| <a name="input_scale_units"></a> [scale\_units](#input\_scale\_units) | (Optional) The number of scale units with which to provision the Bastion Host. Possible values are between 2 and 50. Defaults to 2.<br><br>  Note: scale\_units only can be changed when sku is Standard. scale\_units is always 2 when sku is Basic. | `number` | `2` | no |
| <a name="input_shareable_link_enabled"></a> [shareable\_link\_enabled](#input\_shareable\_link\_enabled) | (Optional) Is Shareable Link feature enabled for the Bastion Host. Defaults to false.<br><br>  Note: shareable\_link\_enabled is only supported when sku is Standard. | `bool` | `false` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | (Optional) The SKU of the Bastion Host. Accepted values are Developer, Basic and Standard. Defaults to Basic.<br><br>  Note: Downgrading the SKU will force a new resource to be created. | `string` | `"Basic"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_tunneling_enabled"></a> [tunneling\_enabled](#input\_tunneling\_enabled) | (Optional) Is Tunneling feature enabled for the Bastion Host. Defaults to false.<br><br>  Note: tunneling\_enabled is only supported when sku is Standard. | `bool` | `false` | no |
| <a name="input_virtual_network_id"></a> [virtual\_network\_id](#input\_virtual\_network\_id) | (Optional) The ID of the Virtual Network for the Developer Bastion Host. Changing this forces a new resource to be created. | `string` | `null` | no |

# Examples

## Example -- Simple developer sku deployment

This example demonstrates a minimialistic provisioning of Azure Bastion in the developer sku. It creates 2 Windows Server virtual machines to test the Bastion. It does not provision any public ip address as that is not necessary in the developer sku. The pre-requisites to provision this are:

1. Enter a valid existing resource group name
1. Enter in a location to deploy your resources. Note that the developer sku is only supported in some regions (e.g `West US`).

To provision this, enter in values to the `variables.tf` file.
```hcl
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

resource "azurerm_subnet" "bastion_subnet_example" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.bastion_vnet_example.name
  address_prefixes     = ["10.2.0.0/24"]
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
  source = "git::https://github.com/mason1999/terraform-windows-vm"

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
  source = "git::https://github.com/mason1999/terraform-windows-vm"

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

module "bastion" {
  source              = "./terraform-bastion"
  name                = "bastion-host"
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_network_id  = azurerm_virtual_network.bastion_vnet_example.id
  sku                 = "Developer"
}
```
To see more examples, visit the [examples](./examples) folder.

# Outputs

No outputs.

# Appendix

This module was created with the help of `terraform-docs`. To automate the creation of the module run:

- `terraform-docs -c terraform-docs.yaml .`
- `./create-table-of-contents.sh "README.md"`
<!-- END_TF_DOCS -->