# Datasources
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group
data "azurerm_resource_group" "rgds" {
  name = azurerm_resource_group.myrg.name
  #depends_on = [ azurerm_resource_group.myrg ]
  #name = local.rg_name
}

## TEST DATASOURCES using OUTPUTS
# 1. Resource Group Name from Datasource
output "ds_rg_name" {
  value = data.azurerm_resource_group.rgds.name
}

# 2. Resource Group Location from Datasource
output "ds_rg_location" {
  value = data.azurerm_resource_group.rgds.location
}

# 3. Resource Group ID from Datasource
output "ds_rg_id" {
  value = data.azurerm_resource_group.rgds.id
}



