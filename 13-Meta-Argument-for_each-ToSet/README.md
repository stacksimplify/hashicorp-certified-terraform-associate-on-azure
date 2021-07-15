---
title: Terraform Resource Meta-Argument for_each toset
description: Learn Terraform Resource Meta-Argument for_each toset
---

## Step-01: Introduction
- Understand about Meta-Argument `for_each`
- Implement `for_each` with **Set of Strings**
- [Resource Meta-Argument: for_each](https://www.terraform.io/docs/language/meta-arguments/for_each.html)
- Understand about [toset function](https://www.terraform.io/docs/language/functions/toset.html)

## Step-02: Terraform toset() function
- `toset` converts its argument to a set value. In short, it does a explicit type conversion to normalize the types. 
- **Important Note-1:** Terraform's concept of a set requires all of the elements to be of the same type, mixed-typed elements will be converted to the most general type
- **Important Note-2:** Set collections are unordered and cannot contain duplicate values, so the ordering of the argument elements is lost and any duplicate values are coalesced
```t
# Terraform console
terraform console

# All Strings to Strings
toset(["kalyan", "reddy", "daida"])

# Mixed Type (Strings and Numbers) - Converted to Strings 
toset(["kalyan", "reddy", 123, 456])

# Removes duplicates (Set collections are unordered and cannot contain duplicate values,) 
toset(["z", "k", "r", "a", "k"])

# Also arranges in the order (The order provided will be gone) - In short set collections are unordered
toset([4, 100, 20, 11, 21, 7, 6, 4, 100])
```


## Step-03: c1-versions.tf
```t
# Terraform Block
terraform {
  required_version = ">= 1.0.0"
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

## Step-04: c2-resource-group.tf - Implement for_each with Maps
```t
# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  for_each = toset(["eastus", "eastus2", "westus"])
  name = "myrg-${each.value}" 
  location = each.key 
  # we can also use each.value as each.key = each.value in this case  
}
```

## Step-05: Execute Terraform Commands
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
1) 3 Resource Groups will be generated in plan
2) Review Resource Names ResourceType.ResourceLocalName[each.key]
3) Review Resource Group name 

# Terarform Apply
terraform apply
Observation: 
1) 3 Azure Resource Groups should be created
2) Review Resource Group names Azure Management console

# Terraform Destroy
terraform destroy

# Clean-Up 
rm -rf .terraform*
rm -rf terraform.tfstate*
```

