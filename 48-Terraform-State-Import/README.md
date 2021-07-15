---
title: Terraform State Import
description: Learn Terraform State Import
---

## Step-01: Introduction
- Terraform is able to import existing infrastructure. 
- This allows you take resources you've created by some other means and bring it under Terraform management.
- This is a great way to slowly transition infrastructure to Terraform, or to be able to be confident that you can use Terraform in the future if it potentially doesn't support every feature you need today.
- [Full Reference](https://www.terraform.io/docs/cli/import/index.html)
- [Azure Resource Group Terraform Import](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group#import)


## Step-02: Create Azure Resource Group using Azure Mgmt Console
- Login to Azure Portal Management Console 
- Go to -> Resource Groups -> Create
- **Resource Group:** myrg1
- **Region:** East US
- Click on **Review + create**
- Click on **Create**


## Step-03: Create Basic Terraform Configuration
- c1-versions.tf
- c2-resource-group.tf
- Create a base Azure Resource Group resource
```t
# Create Azure Resource Group Resource - Basic Version to get Terraform Resource Type and Resource Local Name we are going to use in Terraform
# Resource Group
resource "azurerm_resource_group" "myrg" {
}
```

## Step-04: Run Terraform Import to import Azure Resource Group to Terraform State
```t
# Terraform Initialize
terraform init

# Terraform Import Command for Azure Resource Group
terraform import azurerm_resource_group.example /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example
terraform import azurerm_resource_group.example /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP_NAME>
terraform import azurerm_resource_group.myrg /subscriptions/82808767-144c-4c66-a320-b30791668b0a/resourceGroups/myrg1

Observation:
1) terraform.tfstate file will be created locally in Terraform working directory
2) Review information about imported instance configuration in terraform.tfstate

# List Resources from Terraform State
terraform state list
```

## Step-05: Start Building local c2-resource-group.tf
- By referring `terraform.tfstate` file and parallely running `terraform plan` command make changes to your terraform configuration `c2-resource-group.tf` till you get the message `No changes. Infrastructure is up-to-date` for `terraform plan` output
```t
# Resource Group
resource "azurerm_resource_group" "myrg" {
  name = "myrg1"
  location = "eastus"
}
```
## Step-06: Modify Resource Group from Terraform
- You have created this Azure Resource Group manually and now you made it as terraform managed 
- Modify this resource group by adding new tags
```t
# Resource Group
resource "azurerm_resource_group" "myrg" {
  name = "myrg1"
  location = "eastus"
  tags = {
    "Tag1" = "My-tag-1"
  }
}
```
## Step-07: Execute Terraform Commands
```t
# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-approve
Observation:
1) Azure Resource Group on Azure Cloud should have the recently added tags. 
```

## Step-08: Destroy all resources
- Destroy that using terraform
```t
# Destroy Resource
terraform destroy  -auto-approve

# Clean-Up files
rm -rf .terraform*
rm -rf terraform.tfstate*

# Comment Resource Arguments
Change-1: c2-resource-group.tf
- Comment all resources and uncomment them when learning
```



