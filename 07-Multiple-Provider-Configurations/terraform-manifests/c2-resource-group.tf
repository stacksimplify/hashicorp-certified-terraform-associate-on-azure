# Create a resource group in EastUS region - Uses Default Provider
resource "azurerm_resource_group" "myrg1" {
  name = "myrg-1"
  location = "East US"
}

#Create a resource group in WestUS region - Uses "provider2-westus" provider
resource "azurerm_resource_group" "myrg2" {
  name = "myrg-2"
  location = "West US"
  provider = azurerm.provider2-westus
}


/*
Additional Note: 
provider = <PROVIDER NAME>.<ALIAS NAME>  # This is a Meta-Argument from Resources Section nothing but a Special Argument
*/
