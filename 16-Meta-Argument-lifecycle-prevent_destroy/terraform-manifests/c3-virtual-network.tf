# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"
  #name                = "myvnet-2"  
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

# Lifecycle Changes
  /*lifecycle {
    prevent_destroy = true
  }*/
}

/*
# Changing this forces a new resource to be created.
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
*/

/* Sample Error
Kalyans-MacBook-Pro:v7-terraform-manifests-lifecycle-prevent_destroy kdaida$ terraform apply -auto-approve
random_string.myrandom: Refreshing state... [id=xpeska]
azurerm_resource_group.myrg: Refreshing state... [id=/subscriptions/82808767-144c-4c66-a320-b30791668b0a/resourceGroups/myrg-1]
azurerm_virtual_network.myvnet: Refreshing state... [id=/subscriptions/82808767-144c-4c66-a320-b30791668b0a/resourceGroups/myrg-1/providers/Microsoft.Network/virtualNetworks/myvnet-1]
╷
│ Error: Instance cannot be destroyed
│ 
│   on c3-virtual-network.tf line 2:
│    2: resource "azurerm_virtual_network" "myvnet" {
│ 
│ Resource azurerm_virtual_network.myvnet has lifecycle.prevent_destroy set, but the
│ plan calls for this resource to be destroyed. To avoid this error and continue
│ with the plan, either disable lifecycle.prevent_destroy or reduce the scope of the
│ plan using the -target flag.
╵
Kalyans-MacBook-Pro:v7-terraform-manifests-lifecycle-prevent_destroy kdaida$ 
*/