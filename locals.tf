locals {
  virtual_network_name = try(regex("/virtualNetworks/([a-zA-Z0-9\\-]+)", var.virtual_network_id)[0], null)
}
