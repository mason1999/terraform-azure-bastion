locals {
  resource_group_name = "test-rg"
}

module "example" {
  source              = "./template_module"
  resource_group_name = local.resource_group_name
  complex_paramter    = true
}
