## Example -- Simple standard sku deployment with bastion subnet creation

This example demonstrates a minimialistic provisioning of Azure Bastion in the standard sku. It creates 2 linux virtual machines (with neovim and tmux installed and configured) to test the Bastion. It creates a public Ip address and creates the `AzureBastionSubnet` with appropriate NSG rules configured. To test the following example:

1. Enter a valid existing resource group name
1. Enter in a location to deploy your resources. Note that the developer sku is only supported in some regions (e.g `West US`).

To provision this, enter in values to the `variables.tf` file.
