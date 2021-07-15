---
title: Terraform Input Variables Basics
description: Learn Terraform Input Variables Basics
---

## Step-01: Introduction
- What are Terraform Input Variables ?
- How many ways we can define Terraform Input Variables ?
- Learm about `Input Variables - Basics`

## Step-02: Input Variables Basics 
- Create / Review the terraform manifests
1. c1-versions.tf
2. c2-variables.tf
3. c3-resource-group.tf
4. c4-virtual-network.tf
- We are going to define `c2-variables.tf` and define the below listed variables
```t
# Input Variables

# 1. Business Unit Name
variable "business_unit" {
  description = "Business Unit Name"
  type = string
  default = "hr"
}
# 2. Environment Name
variable "environment" {
  description = "Environment Name"
  type = string
  default = "dev"
}
# 3. Resource Group Name
variable "resoure_group_name" {
  description = "Resource Group Name"
  type = string
  default = "myrg"
}
# 4. Resource Group Location
variable "resoure_group_location" {
  description = "Resource Group Location"
  type = string
  default = "East US"
}
# 5. Virtual Network Name
variable "virtual_network_name" {
  description = "Virtual Network Name"
  type = string 
  default = "myvnet"
}
```

## Step-03: Use the Variables in Resources - c3-resource-group.tf
```t
# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  #name = var.resource_group_name
  name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  location = var.resoure_group_location
}
```

## Step-04: Use the Variables in Resources - c4-virtual-network.tf
```t
# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
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

# Create Resources
terraform apply

# Verify the same on Azure Management Console
1. Resource Group Name
2. Virtual Network Name 
```

## Step-06: Clean-Up
```t
# Clean-Up
terraform destroy -auto-approve
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## References
- [Terraform Input Variables](https://www.terraform.io/docs/language/values/variables.html)


