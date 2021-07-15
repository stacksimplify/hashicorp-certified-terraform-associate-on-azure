# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"
  #name                = "myvnet-2"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

/*
# Lifecycle Changes
  lifecycle {
    create_before_destroy = true
  }
*/
}


/*
# Changing this forces a new resource to be created.
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
*/

