# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  name = local.rg_name
  location = "East US"
  tags = local.common_tags
}