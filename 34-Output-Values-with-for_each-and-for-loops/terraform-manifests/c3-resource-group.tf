# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  name = "myrg1-demo"
  location = var.resoure_group_location
}


