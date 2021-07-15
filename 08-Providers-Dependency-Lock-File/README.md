---
title: Terraform Provider Dependency Lock File
description: Learn about Terraform Provider Dependency Lock File
---

## Step-01: Introduction
- Understand the importance of Dependency Lock File which is introduced in `Terraform v0.14` onwards

## Step-02: Create or Review c1-versions.tf
- c1-versions.tf
1. Discuss about Terraform, Azure and Random Pet Provider Versions
2. Discuss about Azure RM Provider version `1.44.0`
3. In provider block, `features {}` block is not present in Azure RM provider verion `1.44.0`
4. Also discuss about Random Provider
4. [Azure Provider v1.44.0 Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/1.44.0/docs)
```t
# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "1.44.0"
      #version = ">= 2.0" # Commented for Dependency Lock File Demo
    }
    random = {
      source = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

# Provider Block
provider "azurerm" {
# features {}          # Commented for Dependency Lock File Demo
}
```  
## Step-03: Create or Review c2-resource-group-storage-container.tf
- c2-resource-group-storage-container.tf
1. Discuss about [Azure Resource Group Resource](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
2. Discuss about [Random String Resource](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string)
3. Discuss about [Azure Storage Account Resource - Latest](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
4. Discuss about [Azure Storage Account Resource - v1.44.0](https://registry.terraform.io/providers/hashicorp/azurerm/1.44.0/docs/resources/storage_account)
```t
# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg1" {
  name = "myrg-1"
  location = "East US"
}

# Resource-2: Random String 
resource "random_string" "myrandom" {
  length = 16
  upper = false 
  special = false
}

# Resource-3: Azure Storage Account 
resource "azurerm_storage_account" "mysa" {
  name                     = "mysa${random_string.myrandom.id}"
  resource_group_name      = azurerm_resource_group.myrg1.name
  location                 = azurerm_resource_group.myrg1.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  account_encryption_source = "Microsoft.Storage"

  tags = {
    environment = "staging"
  }
}
```
## Step-04: Initialize and apply the configuration
```t
# We will start with Base v1.44 `.terraform.lock.hcl` file
cp .terraform.lock.hcl-v1.44 .terraform.lock.hcl
Observation: This will ensure, when we run terraform init, everything related to providers will be picked from this file

# Initialize Terraform
terraform init

# Compare both files
diff .terraform.lock.hcl-v1.44 .terraform.lock.hcl

# Validate Terraform Configuration files
terraform validate

# Execute Terraform Plan
terraform plan

# Create Resources using Terraform Apply
terraform apply
```
- Discuss about following 3 items in `.terraform.lock.hcl`
1. Provider Version
2. Version Constraints 
3. Hashes


## Step-05: Upgrade the Azure provider version
- For Azure Provider, with version constraint `version = ">= 2.0.0"`, it is going to upgrade to latest version with command `terraform init -upgrade` 
```t
# c1-versions.tf - Comment 1.44.0  and Uncomment ">= 2.0"
      #version = "1.44.0"
      version = ">= 2.0" 

# Upgrade Azure Provider Version
terraform init -upgrade

# Backup
cp .terraform.lock.hcl terraform.lock.hcl-V2.X.X
```
- Review **.terraform.lock.hcl**
1. Discuss about Azure Provider Versions
2. Compare `.terraform.lock.hcl-v1.44` & `terraform.lock.hcl-V2.X.X`

## Step-06: Run Terraform Apply with latest Azure Provider
- Should fail due to argument `account_encryption_source` for Resource `azurerm_storage_account` not present in Azure v2.x provider when compared to Azure v1.x provider
```t
# Terraform Plan
terraform plan

# Terraform Apply
terraform apply
```
- **Error Message**
```log
Kalyans-MacBook-Pro:terraform-manifests kdaida$ terraform plan
╷
│ Error: Unsupported argument
│ 
│   on c2-resource-group-storage-container.tf line 21, in resource "azurerm_storage_account" "mysa":
│   21:   account_encryption_source = "Microsoft.Storage"
│ 
│ An argument named "account_encryption_source" is not expected here.
╵
Kalyans-MacBook-Pro:terraform-manifests kdaida$ 
```

## Step-07: Comment account_encryption_source
- When we do a major version upgrade to providers, it might break few features. 
- So with `.terraform.lock.hcl`, we can avoid this type of issues by maintaining our Provider versions consistent across any machine by having a copy of `.terraform.lock.hcl` file with us. 
```t
# Comment account_encryption_source Attribute
# Resource-3: Azure Storage Account 
resource "azurerm_storage_account" "mysa" {
  name                     = "mysa${random_string.myrandom.id}"
  resource_group_name      = azurerm_resource_group.myrg1.name
  location                 = azurerm_resource_group.myrg1.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  #account_encryption_source = "Microsoft.Storage"

  tags = {
    environment = "staging"
  }
}
```

## Step-08: Uncomment or add features block in Azure Provider Block
- As part of Azure Provider 2.x.x latest versions, it needs `features {}` block in Provider block. 
- Please Uncomment `features {}` block
```t
# Provider Block
provider "azurerm" {
 features {}          
}
```
- Error Log of features block not present 
```log
Kalyans-MacBook-Pro:terraform-manifests kdaida$ terraform plan
╷
│ Error: Insufficient features blocks
│ 
│   on  line 0:
│   (source code not available)
│ 
│ At least 1 "features" blocks are required.
╵
Kalyans-MacBook-Pro:terraform-manifests kdaida$ 

```

## Step-09: Run Terraform Plan and Apply
- Everything should pass and Storage account should migrate to `StorageV2` 
- Also Azure Provider v2.x default changes should be applied
```t
# Terraform Plan
terraform plan

# Terraform Apply
terraform apply
```


## Step-10: Clean-Up
```t
# Destroy Resources
terraform destroy

# Delete Terraform Files
rm -rf .terraform    
rm -rf .terraform.lock.hcl
Observation:  We are not removing files named ".terraform.lock.hcl-V2.X.X, .terraform.lock.hcl-V1.44" which are needed for this demo for you.

# Delete Terraform State File
rm -rf terraform.tfstate*
```

## Step-11: To put back this to original demo state for students to have seamless demo
```t
# Change-1: c1-versions.tf
      version = "1.44.0"
      #version = ">= 2.0" 

# Change-2: c1-versions.tf: Features block in commented state
# features {}          

# Change-3: c2-resource-group-storage-container.tf 
  account_encryption_source = "Microsoft.Storage"
```

## References
- [Random Pet Provider](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet)
- [Dependency Lock File](https://www.terraform.io/docs/configuration/dependency-lock.html)
- [Terraform New Features in v0.14](https://learn.hashicorp.com/tutorials/terraform/provider-versioning?in=terraform/0-14)
