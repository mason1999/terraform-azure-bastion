## Example -- Simple developer sku deployment

This example demonstrates a minimialistic provisioning of Azure Bastion in the developer sku. It creates 2 Windows Server virtual machines to test the Bastion. It does not provision any public ip address as that is not necessary in the developer sku. The pre-requisites to provision this are:

1. Enter a valid existing resource group name
1. Enter in a location to deploy your resources. Note that the developer sku is only supported in some regions (e.g `West US`).

To provision this, enter in values to the `variables.tf` file.
