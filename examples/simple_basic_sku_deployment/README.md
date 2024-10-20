## Example -- Simple basic sku deployment

This example demonstrates a minimialistic provisioning of Azure Bastion in the basic sku. It creates 2 linux virtual machines (with neovim and tmux installed and configured) to test the Bastion. It creates a public Ip address.

1. Enter a valid existing resource group name
1. Enter in a location to deploy your resources. Note that the developer sku is only supported in some regions (e.g `West US`).

To provision this, enter in values to the `variables.tf` file.
