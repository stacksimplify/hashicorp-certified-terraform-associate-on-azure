# 1. Output Values - Resource Group
output "resource_group_id" {
  description = "Resource Group ID"
  # Atrribute Reference
  value = azurerm_resource_group.myrg.id 
}
output "resource_group_name" {
  description = "Resource Group name"
  # Argument Reference
  value = azurerm_resource_group.myrg.name  
}

# 2. Output Values - Virtual Network
/*
output "virtual_network_name" {
  description = "Virutal Network Name"
  value = azurerm_virtual_network.myvnet[*].name   
  #sensitive = true
}
*/


# Output - For Loop One Input and List Output with VNET Name 
output "virtual_network_name_list_one_input" {
  description = "Virtual Network - For Loop One Input and List Output with VNET Name "
  value = [for vnet in azurerm_virtual_network.myvnet: vnet.name ]  
}

# Output - For Loop Two Inputs, List Output which is Iterator i (var.environment)
output "virtual_network_name_list_two_inputs" {
  description = "Virtual Network - For Loop Two Inputs, List Output which is Iterator i (var.environment)"  
  #value = [for i, vnet in azurerm_virtual_network.myvnet: i ]
  value = [for env, vnet in azurerm_virtual_network.myvnet: env ]
}

# Output - For Loop One Input and Map Output with VNET ID and VNET Name
output "virtual_network_name_map_one_input" {
  description = "Virtual Network - For Loop One Input and Map Output with VNET ID and VNET Name"
  value = {for vnet in azurerm_virtual_network.myvnet: vnet.id => vnet.name }
}

# Output - For Loop Two Inputs and Map Output with Iterator env and VNET Name
output "virtual_network_name_map_two_inputs" {
  description = "Virtual Network - For Loop Two Inputs and Map Output with Iterator env and VNET Name"
  value = {for env, vnet in azurerm_virtual_network.myvnet: env => vnet.name }
}

# Terraform keys() function: keys takes a map and returns a list containing the keys from that map.
output "virtual_network_name_keys_function" {
  description = "Virtual Network - Terraform keys() function"
  value = keys({for env, vnet in azurerm_virtual_network.myvnet: env => vnet.name })
}

# Terraform values() function: values takes a map and returns a list containing the values of the elements in that map.
output "virtual_network_name_values_function" {
  description = "Virtual Network - Terraform values() function"
  value = values({for env, vnet in azurerm_virtual_network.myvnet: env => vnet.name })
}
