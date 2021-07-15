# Local Values Block
locals {
  # Use-case-1: Shorten the names for more readability
  rg_name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  vnet_name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  snet_name = "${var.business_unit}-${var.environment}-${var.subnet_name}"
  pip_name = "${var.business_unit}-${var.environment}-${var.publicip_name}"
  nic_name = "${var.business_unit}-${var.environment}-${var.network_interface_name}"
  vm_name = "${var.business_unit}-${var.environment}-${var.virtual_machine_name}"
  
  # Use-case-2: Common tags to be assigned to all resources
  service_name = "Demo Services"
  owner = "Kalyan Reddy Daida"
  common_tags = {
    Service = local.service_name
    Owner   = local.owner
    #Tag = "demo-tag1"
  }
}