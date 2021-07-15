---
title: Terraform Command Basics
description: Learn Terraform Commands like init, validate, plan, apply and destroy
---

## Step-01: Introduction
- Understand basic Terraform Commands
1. terraform init
2. terraform validate
3. terraform plan
4. terraform apply
5. terraform destroy      

[![Image](https://stacksimplify.com/course-images/azure-terraform-workflow-1.png "HashiCorp Certified: Terraform Associate on Azure")](https://stacksimplify.com/course-images/azure-terraform-workflow-1.png)

[![Image](https://stacksimplify.com/course-images/azure-terraform-workflow-2.png "HashiCorp Certified: Terraform Associate on Azure")](https://stacksimplify.com/course-images/azure-terraform-workflow-2.png)

## Step-02: Review terraform manifests
- **Pre-Conditions-1:** Get Azure Regions and decide the region where you want to create resources
```t
# Get Azure Regions
az account list-locations -o table
```
- **Pre-Conditions-2:** If not done earlier, complete `az login` via Azure CLI. We are going to use Azure CLI Authentication for Terraform when we use Terraform Commands. 
```t
# Azure CLI Login
az login

# List Subscriptions
az account list

# Set Specific Subscription (if we have multiple subscriptions)
az account set --subscription="SUBSCRIPTION_ID"
```
- [Azure Regions](https://docs.microsoft.com/en-us/azure/virtual-machines/regions)
- [Azure Regions Detailed](https://docs.microsoft.com/en-us/azure/best-practices-availability-paired-regions#what-are-paired-regions)
```t
# Terraform Settings Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" # Optional but recommended in production
    }    
  }
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
# Create Resource Group 
resource "azurerm_resource_group" "my_demo_rg1" {
  location = "eastus"
  name = "my-demo-rg1"  
}
```

## Step-03: Terraform Core Commands
```t
# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan to Verify what it is going to create / update / destroy
terraform plan

# Terraform Apply to Create Resources
terraform apply 
```

## Step-04: Verify Azure Resource Group in Azure Management Console
- Go to Azure Management Console -> Resource Groups 
- Verify newly created Resource Group
- Review `terraform.tfstate` file 

## Step-05: Destroy Infrastructure
```t
# Destroy Azure Resource Group 
terraform destroy
Observation:
1. Verify if the resource group got deleted in Azure Management Console
2. Verify terraform.tfstate file and resource group info should be removed
3. Verify terraform.tfstate.backup, it should have the resource group info here stored as backup. 

# Delete Terraform files 
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## Step-08: Conclusion
- Re-iterate what we have learned in this section
- Learned about Important Terraform Commands
1. terraform init
2. terraform validate
3. terraform plan
4. terraform apply
5. terraform destroy      
 



