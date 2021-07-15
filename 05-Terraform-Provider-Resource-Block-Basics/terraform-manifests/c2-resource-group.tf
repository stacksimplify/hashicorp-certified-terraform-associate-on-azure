# Resource Block
# Create a resource group
resource "azurerm_resource_group" "myrg" {
  name = "myrg-1"
  location = "East US"
}