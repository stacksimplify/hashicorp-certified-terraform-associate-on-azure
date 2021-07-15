# 1. Output Values for Resource Group Resource
output "resource_group_id" {
  description = "Resource Group ID"
  # Attribute Reference
  value = azurerm_resource_group.myrg.id 
}
output "resource_group_name" {
  description = "Resource Group Name"
  # Argument Reference
  value = azurerm_resource_group.myrg.name
}

# 2. Output Values for Virtual Network Resource
output "virtual_network_name" {
  description = "Virtal Network Name"
  value = azurerm_virtual_network.myvnet.name  
  #sensitive = true  # Enable during Step-08
}


