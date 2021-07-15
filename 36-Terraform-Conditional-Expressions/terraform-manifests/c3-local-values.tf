# Local Values Block
locals {
  # Use-case-1: Shorten the names for more readability
  rg_name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  vnet_name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"

  # Use-case-2: Common tags to be assigned to all resources
  service_name = "Demo Services"
  owner = "Kalyan Reddy Daida"
  common_tags = {
    Service = local.service_name
    Owner   = local.owner
  }

  # Use-case-3: Terraform Conditional Expressions
  # We will learn this when we are dealing with Conditional Expressions
  # The expressions assigned to local value names can either be simple constants or can be more complex expressions that transform or combine values from elsewhere in the module.
  # Option-1: With Equals (==)
  vnet_address_space = (var.environment == "dev" ? var.vnet_address_space_dev : var.vnet_address_space_all)
  # Option-2: With Not Equals (!=)
  #vnet_address_space = (var.environment != "dev" ? var.vnet_address_space_all : var.vnet_address_space_dev )
}