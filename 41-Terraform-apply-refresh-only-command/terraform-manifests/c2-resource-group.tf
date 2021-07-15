# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  name = "myrg1"
  location = "eastus"
  tags = {
    "tag1" = "my-tag-1"
    "tag2" = "my-tag-2"
    "tag3" = "my-tag-3"
  }
}