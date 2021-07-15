---
title: Terraform Datasources
description: Learn about Terraform Datasources
---
## Step-01: Introduction
- Understand about Datasources in Terraform
- Implement a sample usecase with Datasources.
1. Datasource [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group)
2. Datasource [azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network)
3. Datasource [azurerm_subscription](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription)

## Step-02: c6-datasource-resource-group.tf
```t
# Datasources
data "azurerm_resource_group" "rgds" {
  depends_on = [ azurerm_resource_group.myrg ]
  name = local.rg_name 
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
```

## Step-03: c7-datasource-virtual-network.tf
```t
# Datasources
data "azurerm_virtual_network" "vnetds" {
  depends_on = [ azurerm_virtual_network.myvnet ]
  name = local.vnet_name
  resource_group_name = local.rg_name
}

## TEST DATASOURCES using OUTPUTS
# 1. Virtual Network Name from Datasource
output "ds_vnet_name" {
  value = data.azurerm_virtual_network.vnetds.name 
}

# 2. Virtual Network ID from Datasource
output "ds_vnet_id" {
  value = data.azurerm_virtual_network.vnetds.id 
}

# 3. Virtual Network address_space from Datasource
output "ds_vnet_address_space" {
  value = data.azurerm_virtual_network.vnetds.address_space
}
```
## Step-04: c8-datasource-subscription.tf
```t
# Datasources
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription
data "azurerm_subscription" "current" {
}

## TEST DATASOURCES using OUTPUTS
# 1. My Current Subscription Display Name
output "current_subscription_display_name" {
  value = data.azurerm_subscription.current.display_name
}

# 2. My Current Subscription Id
output "current_subscription_id" {
  value = data.azurerm_subscription.current.subscription_id
}

# 3. My Current Subscription Spending Limit
output "current_subscription_spending_limit" {
  value = data.azurerm_subscription.current.spending_limit
}
```
## Step-05: Execute Terraform Commands
```t
# Initialize Terraform
terraform init

# Validate Terraform configuration files
terraform validate

# Format Terraform configuration files
terraform fmt

# Review the terraform plan
terraform plan 
Observation: 
1. Verify the Resource Group Datasource Outputs
2. Verify the Virtual Network Datasource Outputs
3. Verify the Subscription Datasource Outputs

# Create Resources (Optional)
terraform apply -auto-approve
```
## Step-06: c9-datasource-resource-group-existing.tf
- Create a Resource group named `dsdemo` in Azure using Azure Managment Console
- Using Datasources TF Config listed below try and access the information 
- Uncomment the contents in this file `c9-datasource-resource-group-existing.tf` during this step execution.
```t
# Datasources
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group
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
```
## Step-07: Execute Terraform Commands
```t
# Terraform Plan
terraform plan

# Observation
1. You should get the "dsdemo" resource group created on Azure Portal manually in outputs. 

# Comment Content in c9-datasource-resource-group-existing.tf
Comment the contents in this file `c9-datasource-resource-group-existing.tf` after the above steps execution.
```

## Step-08: Clean-Up
```t
# Destroy Resources
terraform destroy -auto-approve

# Delete Files
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## References
- [Terraform Datasource](https://www.terraform.io/docs/language/data-sources/index.html)
