# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  for_each = var.environment
  name = "${var.business_unit}-${each.key}-${var.resoure_group_name}"
  location = var.resoure_group_location
}