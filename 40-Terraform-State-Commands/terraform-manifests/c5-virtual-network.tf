# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {     # Comment during step-05-02
#resource "azurerm_virtual_network" "myvnet-new" {  # Uncomment during step-05-02
  name                = local.vnet_name # Comment during step-05-03
  #name                = "${local.vnet_name}-2" # Uncomment during step-05-03
  address_space       = local.vnet_address_space      # Comment at Step-08 
  #address_space       = ["10.0.0.0/16", "10.1.0.0/16"] # Uncomment at Step-08
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags = local.common_tags 
}


# Another VNET - New Resource - Uncomment the below at step-08
/*
resource "azurerm_virtual_network" "myvent9" {
  name = "myvnet9"
  address_space = [ "10.2.0.0/16" ]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name  
}
*/

