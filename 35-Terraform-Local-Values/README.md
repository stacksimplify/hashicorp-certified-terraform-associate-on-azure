---
title: Terraform Local Values
description: Learn about Terraform Local Values
---
## Step-01: Introduction
- Understand DRY Principle
- What is local value in terraform?
- When To Use Local Values?
- What is the problem locals are solving ?

```t
What is DRY Principle ?
Don't repeat yourself

What is local value in terraform?
The local block defines one or more local variables within a module. 
A local value assigns a name to an terraform expression, allowing it to be used multiple times within a module without repeating it.

When To Use Local Values?
Local values can be helpful to avoid repeating the same values or expressions multiple times in a configuration
If overused they can also make a configuration hard to read by future maintainers by hiding the actual values used.
Use local values only in moderation, in situations where a single value or result is used in many places and that value is likely to be changed in future. The ability to easily change the value in a central place is the key advantage of local values.

What is the problem locals are solving ?
Currently terraform doesn’t allow variable substitution within variables. The terraform way of doing this is by using local values or locals where you can somehow keep your code DRY.

Another use case (at least for me) for locals is to shorten references on upstream terraform projects as seen below. This will make your terraform templates/modules more readable.

We can define as many local blocks as required in that respective Module.  The names given for the items in the local block must be unique throughout a module.
```

## Step-02: c1-versions.tf
```t
# Terraform Block
terraform {
  required_version = ">= 0.15"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }
  }
}
# Provider Block
provider "azurerm" {
 features {}          
}
```

## Step-03: c2-variables.tf
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

## Step-04: c3-local-values.tf
```t
# Local Values Block

locals {
  # Use-case-1: Shorten the names for more readability
  rg_name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  vnet_name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"

  # Use-case-2: Common tags to be assigned to all resources
  service_name = "Demo Services"
  owner = "Kalyan Reddy"
  common_tags = {
    Service = local.service_name
    Owner   = local.owner
  }

  # Use-case-3: Terraform Dynamic or Conditional Expressions
  # We will learn this when we are dealing with Dynamic Expressions
  # The expressions assigned to local value names can either be simple constants or can be more complex expressions that transform or combine values from elsewhere in the module.
}
```

## Step-05: c4-resource-group.tf
```t
# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  #name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  name = local.rg_name
  location = var.resoure_group_location
  tags = local.common_tags
}
```

## Step-06: c5-virtual-network.tf
```t
# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  #name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  name                = local.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags = local.common_tags
}

```

## Step-07: Execute Terraform Commands
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
1. Verify Resource Group Name
2. Verify Virtual Network Name
3. Verify Common Tags for Resource Group and Virtual Network.

# Create Resources (Optional)
terraform apply -auto-approve
Observation: Review the below directly in Azure Management Console
1. Verify Resource Group Name
2. Verify Virtual Network Name
3. Verify Common Tags for Resource Group and Virtual Network.

```

## Step-08: Clean-Up
```t
# Destroy Resources
terraform destroy -auto-approve

# Delete files
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## References
- [Terraform Local values](https://www.terraform.io/docs/language/values/locals.html)