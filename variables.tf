variable "name" {
  description = "(Required) Specifies the name of the Bastion Host. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Bastion Host. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. Review Azure Bastion Host FAQ for supported locations."
  type        = string
}

variable "sku" {
  description = <<EOF
  (Optional) The SKU of the Bastion Host. Accepted values are Developer, Basic and Standard. Defaults to Basic.

  Note: Downgrading the SKU will force a new resource to be created.
  EOF
  type        = string
  default     = "Basic"
  validation {
    condition     = contains(["Developer", "Basic", "Standard"], var.sku)
    error_message = "Accepted values for sku are [Developer, Basic, Standard]."
  }
}

variable "virtual_network_id" {
  description = "(Optional) The ID of the Virtual Network for the Developer Bastion Host. Changing this forces a new resource to be created."
  type        = string
  default     = null

  validation {
    condition     = can(regex("^/subscriptions/[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}/resourceGroups/[-\\w]+/providers/Microsoft.Network/virtualNetworks/[-\\w]+$", var.virtual_network_id))
    error_message = "Please enter a valid virtual network id."
  }
}

variable "create_azure_bastion_subnet" {
  description = <<EOF
  (Optional) Boolean flag to create the azure bastion subnet and associate network security rules. Defaults to false.
  EOF
  type        = bool
  default     = false
}

variable "azure_bastion_subnet_address_prefixes" {
  description = <<EOF
  (Optional) Address prefixes for azure bastion subnet to be created. Required when create_azure_bastion_subnet is set to true.
  EOF
  type        = list(string)
  default     = []

  validation {
    condition     = var.create_azure_bastion_subnet == false || alltrue([for cidr in var.azure_bastion_subnet_address_prefixes : can(cidrhost(cidr, 0))])
    error_message = "If create_azure_bastion_subnet is true, you must enter a list of valid cidr ranges for subnets"
  }
}

variable "azure_bastion_subnet_id" {
  description = "(Optional) A subnet which has at least a size of /26 which is named AzureBastionSubnet. Required if create_azure_bastion_subnet is false."
  type        = string
  default     = null

  validation {
    condition     = var.create_azure_bastion_subnet == true || can(regex("^/subscriptions/[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}/resourceGroups/[-\\w]+/providers/Microsoft.Network/virtualNetworks/[-\\w]+/subnets/$[-\\w]+", var.azure_bastion_subnet_id))
    error_message = "Please enter a valid virtual network id."
  }
}

variable "copy_paste_enabled" {
  description = "(Optional) Is Copy/Paste feature enabled for the Bastion Host. Defaults to true."
  type        = bool
  default     = true
}

variable "file_copy_enabled" {
  description = <<EOF
  (Optional) Is File Copy feature enabled for the Bastion Host. Defaults to false.

  Note: file_copy_enabled is only supported when sku is Standard.
  EOF
  type        = bool
  default     = false
}

variable "ip_connect_enabled" {
  description = <<EOF
  (Optional) Is IP Connect feature enabled for the Bastion Host. Defaults to false.

  Note: ip_connect_enabled is only supported when sku is Standard.
  EOF
  type        = bool
  default     = false
}

variable "kerberos_enabled" {
  description = <<EOF
  (Optional) Is Kerberos authentication feature enabled for the Bastion Host. Defaults to false.

  Note: kerberos_enabled is only supported when sku is Standard.
  EOF
  type        = bool
  default     = false
}

variable "scale_units" {
  description = <<EOF
  (Optional) The number of scale units with which to provision the Bastion Host. Possible values are between 2 and 50. Defaults to 2.

  Note: scale_units only can be changed when sku is Standard. scale_units is always 2 when sku is Basic.
  EOF
  type        = number
  default     = 2
}

variable "shareable_link_enabled" {
  description = <<EOF
  (Optional) Is Shareable Link feature enabled for the Bastion Host. Defaults to false.

  Note: shareable_link_enabled is only supported when sku is Standard.
  EOF
  type        = bool
  default     = false
}

variable "tunneling_enabled" {
  description = <<EOF
  (Optional) Is Tunneling feature enabled for the Bastion Host. Defaults to false.

  Note: tunneling_enabled is only supported when sku is Standard.
  EOF
  type        = bool
  default     = false
}

variable "tags" {
  description = <<EOF
  (Optional) A mapping of tags to assign to the resource.
  EOF
  type        = map(string)
  default     = {}
}
