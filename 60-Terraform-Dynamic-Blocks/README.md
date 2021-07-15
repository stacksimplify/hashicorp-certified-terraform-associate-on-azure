---
title: Terraform Dynamic Blocks
description: Learn about Terraform Dynamic Blocks
---

## Step-01: Introduction
- Understand about [Dynamic Block](https://www.terraform.io/docs/language/expressions/dynamic-blocks.html)
- Some resource types include repeatable nested blocks in their arguments, which do not accept expressions
- You can dynamically construct repeatable nested blocks like setting using a `special dynamic block type`, which is supported inside resource, data, provider, and provisioner blocks
- Understand and use [sum function](https://www.terraform.io/docs/language/functions/sum.html) using `Terraform Console`
- [Azure Network Resource Group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group)

## Step-02: Review c1-versions.tf
- Standard file without any changes
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

## Step-03: Review c2-resource-group.tf
```t
# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  name = "myrg-1"
  location = "East US"
}
```

## Step-04: Review c3-network-security-group-regular.tf
```t
# Resource-2: Create Network Security Group
resource "azurerm_network_security_group" "mynsg" {
  name                = "mynsg-1"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  security_rule {
    name                       = "inbound-rule-1"
    description                = "Inbound SSH Rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "22"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "inbound-rule-2"
    description                = "Inbound HTTP Rule"    
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "80"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "inbound-rule-3"
    description                = "Inbound Tomcat Rule"    
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "8080"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "outbound-rule-1"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  } 
  tags = {
    environment = "Dev"
  }
}
```

## Step-05: Terraform Sum Function using Terraform Console
```t
# Terraform Console
sum([100,1])
sum([100,2])
```

## Step-06: c4-network-security-group-dynamic-block.tf
- security_rule.key = 0 and security_rule.value = 22
- security_rule.key = 1 and security_rule.value = 80
- security_rule.key = 2 and security_rule.value = 8080  ....
```t
# Define Ports as a list in locals block
locals {
  ports = [22, 80, 8080, 8081, 7080, 7081] 
}
# Resource-2: Create Network Security Group
# Define Ports as a list in locals block
locals {
  ports = [22, 80, 8080, 8081, 7080, 7081]
}

# Resource-2: Create Network Security Group
resource "azurerm_network_security_group" "mynsg2" {
  name                = "mynsg-2"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  dynamic "security_rule" {
    for_each = local.ports 
    content {
      name                       = "inbound-rule-${security_rule.key}"
      #name                       = "inbound-rule-${security_rule.value}"
      description                = "Inbound Rule ${security_rule.key}"    
      priority                   = sum([100, security_rule.key])
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = security_rule.value
      destination_port_range     = security_rule.value
      source_address_prefix      = "*"
      destination_address_prefix = "*"      
    }
  }
 
  security_rule {
    name                       = "Outbound-rule-1"
    description                = "Outbound Rule"    
    priority                   = 102
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }    
  tags = {
    environment = "Dev"
  }  
}
```

## Step-07: Execute Terraform Commands
```t
# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-approve
```

## Step-08: Clean-Up
```t
# Terraform Destroy
terraform destroy -auto-approve

# Delete Files
rm -rf .terraform*
rm -rf terraform.tfstate*
```