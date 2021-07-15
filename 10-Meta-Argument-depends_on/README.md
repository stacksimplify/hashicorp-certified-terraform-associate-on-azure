---
title: Terraform Resource Meta-Argument depends_on
description: Learn Terraform Resource Meta-Argument depends_on
---

## Step-01: Introduction
- We will create the below Azure Resources using Terraform
1. Azure Resource Group
2. Azure Virtual Network
3. Azure Subnet
4. Azure Public IP
5. Azure Network Interface
- Use `depends_on` Resource Meta-Argument attribute when creating Azure Public IP


## Step-02: c1-versions.tf - Create Terraform & Provider Blocks 
- Create Terraform Block
- Create Provider Block
- Create Random Resource Block
```t
# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }
    random = {
      source = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

# Provider Block
provider "azurerm" {
 features {}          
}

# Random String Resource
resource "random_string" "myrandom" {
  length = 6
  upper = false 
  special = false
  number = false   
}
```
## Step-03: c2-resource-group.tf
```t
# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  name = "myrg-1"
  location = "East US"
}
```

## Step-04: c3-vritual-network.tf - Virtual Network Resource
```t
# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}
```

## Step-05: c3-vritual-network.tf  - Azure Subnet Resource
```t
# Create Subnet
resource "azurerm_subnet" "mysubnet" {
  name                 = "mysubnet-1"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
```
## Step-06: c3-vritual-network.tf  - Azure Public IP Resource
```t

# Create Public IP Address
resource "azurerm_public_ip" "mypublicip" {
  name                = "mypublicip-1"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label = "app1-vm-${random_string.myrandom.id}"
  tags = {
    environment = "Dev"
  }
}
``` 
## Step-07: c3-vritual-network.tf  - Network Interface Resource
```t
# Create Network Interface
resource "azurerm_network_interface" "myvmnic" {
  name                = "vmnic"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.mypublicip.id 
  }
}
```

## Step-08: Execute Terraform commands in terraform-manifests-v1
```t
# Change Directory
cd terraform-manifests-v1

# Initialize Terraform
terraform init

# Terraform Validate
terraform validate

# Terraform Plan 
terraform plan

# Terraform Apply 
terraform apply 

# Observation
1. Public IP Resource will get created in parallel with Virtual Network Resource

# Terraform Destroy 
terraform destroy -auto-approve

# Clean-Up
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## Step-09: c3-virtual-network.tf - depends_on for azurerm_public_ip
-  We will review this in `terraform-manifests-v2` folder
```t

# Create Public IP Address
resource "azurerm_public_ip" "mypublicip" {
  # Add Explicit Dependency to have this resource created only after Virtual Network and Subnet Resources are created. 
  depends_on = [
    azurerm_virtual_network.myvnet,
    azurerm_subnet.mysubnet
  ]
  name                = "mypublicip-1"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label = "app1-vm-${random_string.myrandom.id}"
  tags = {
    environment = "Dev"
  }
}
```

## Step-10: Execute Terraform commands in terraform-manifests-v2
```t
# Change Directory
cd terraform-manifests-v2

# Initialize Terraform
terraform init

# Terraform Validate
terraform validate

# Terraform Plan 
terraform plan

# Terraform Apply 
terraform apply 

# Observation
1. Public IP Resource will get created only afer Virtual Network and Subnet Resource got created.
2. As we have defined explicit dependency `depends_on` in Public IP Resource, it will wait till those two other resources got created. 
3. Important Point to remember is "Explicitly specifying a dependency is only necessary when a resource or module relies on some other resource's behavior but doesn't access any of that resource's data in its arguments."

# Terraform Destroy 
terraform destroy -auto-approve

# Clean-Up
rm -rf .terraform*
rm -rf terraform.tfstate*
```



## References 
1. [Azure Resource Group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
2. [Azure Virtual Network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network)
3. [Azure Subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)
4. [Azure Public IP](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip)
5. [Azure Network Interface](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface)
6. [Azure Virtual Machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine)