# Datasources
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group
/*
data "azurerm_resource_group" "rgds1" {
  name = "dsdemo"
}

## TEST DATASOURCES using OUTPUTS
# 1. Resource Group Name from Datasource
output "ds_rg_name1" {
  value = data.azurerm_resource_group.rgds1.name
}

# 2. Resource Group Location from Datasource
output "ds_rg_location1" {
  value = data.azurerm_resource_group.rgds1.location
}

# 3. Resource Group ID from Datasource
output "ds_rg_id1" {
  value = data.azurerm_resource_group.rgds1.id
}
*/


