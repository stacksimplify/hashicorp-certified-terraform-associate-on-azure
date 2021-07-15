---
title: Terraform Configuration Language Syntax
description: Learn Terraform Configuration Language Syntax like Blocks, Arguments, Comments etc
---

## Step-01: Introduction
- Understand Terraform Language Basics
1. Understand Blocks
2. Understand Arguments, Attributes & Meta-Arguments
3. Understand Identifiers
4. Understand Comments


## Step-02: Terraform Configuration Language Syntax
- Understand Blocks
- Understand Arguments
- Understand Identifiers
- Understand Comments
- [Terraform Configuration](https://www.terraform.io/docs/configuration/index.html)
- [Terraform Configuration Syntax](https://www.terraform.io/docs/configuration/syntax.html)
```t
# Template
<BLOCK TYPE> "<BLOCK LABEL>" "<BLOCK LABEL>"   {
  # Block body
  <IDENTIFIER> = <EXPRESSION> # Argument
}

# Azure Example
# Create a resource group
resource "azurerm_resource_group" "myrg" { # Resource BLOCK
  name = "myrg-1" # Argument
  location = "East US" # Argument 
}
# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" { # Resource BLOCK
  name                = "myvnet-1" # Argument
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location # Argument with value as expression
  resource_group_name = azurerm_resource_group.myrg.name # Argument with value as expression
}
```

## Step-03: Understand about Arguments, Attributes and Meta-Arguments.
- Arguments can be `required` or `optional`
- Attribues format looks like `resource_type.resource_name.attribute_name`
- Meta-Arguments change a resource type's behavior (Example: count, for_each)
- [Additional Reference](https://learn.hashicorp.com/tutorials/terraform/resource?in=terraform/configuration-language) 
- [Resource: Azure Resource Group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group)
- [Resource: Azure Resource Group Argument Reference](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group#arguments-reference)
- [Resource: Azure Resource Group Attribute Reference](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group#attributes-reference)
- [Resource: Meta-Arguments](https://www.terraform.io/docs/language/meta-arguments/depends_on.html)

## Step-04: Understand about Terraform Top-Level Blocks
- Discuss about Terraform Top-Level blocks
1. Terraform Settings Block
2. Provider Block
3. Resource Block
4. Input Variables Block
5. Output Values Block
6. Local Values Block
7. Data Sources Block
8. Modules Block

