variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Bastion Host. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. Review Azure Bastion Host FAQ for supported locations."
  type        = string
}
