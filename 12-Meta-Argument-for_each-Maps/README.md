---
title: Terraform Resource Meta-Argument for_each Maps
description: Learn Terraform Resource Meta-Argument for_each Maps
---

## Step-01: Introduction
- Understand about Meta-Argument `for_each`
- Implement `for_each` with **Maps**
- [Resource Meta-Argument: for_each](https://www.terraform.io/docs/language/meta-arguments/for_each.html)


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

## Step-03: c2-resource-group.tf - Implement for_each with Maps
```t
# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  for_each = {
    dc1apps = "eastus"
    dc2apps = "eastus2"
    dc3apps = "westus"
  }
  name = "${each.key}-rg"
  location = each.value
}
```

## Step-03: Execute Terraform Commands
```t
# Terraform Init
terraform init

# Terraform Validate
terraform validate

# Terraform Format
terraform fmt

# Terraform Plan
terraform plan
Observation: 
1) 3 Resource Groups Resources will be generated in plan
2) Review Resource Names ResourceType.ResourceLocalName[each.key] in Terraform Plan
3) Review Resource Group Names 

# Terraform Apply
terraform apply
Observation: 
1) 3 Resource Group will be created
2) Review Resource Group names in Azure Management console

# Terraform Destroy
terraform destroy

# Clean-Up 
rm -rf .terraform*
rm -rf terraform.tfstate*
```
