---
title: Terraform Module Sources
description: Learn more about Terraform Module Sources
---

## Step-01: Introduction
- [Terraform Module Sources](https://www.terraform.io/docs/language/modules/sources.html)
- Understand various Terraform Module Sources

## Step-02: c3-static-website.tf
```t
# Call our Custom Terraform Module which we built earlier
module "azure_static_website" {
  
  # Terraform Local Module
  #source = "./modules/azure-static-website"  
  
  # Terraform Public Registry
  #source  = "stacksimplify/staticwebsitepb/azurerm"
  #version = "1.0.0"

  # Terraform Local Module
  #source = "./modules/azure-static-website"  
  
  # Terraform Public Registry
  #source  = "stacksimplify/staticwebsitepb/azurerm"
  #version = "1.0.0"

  # Github Clone over HTTPS 
  source = "github.com/stacksimplify/terraform-azurerm-staticwebsitepublic"

  # Github Clone over SSH (if git SSH configured with your repo - https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh)
  #source = "git@github.com:stacksimplify/terraform-azurerm-staticwebsitepublic.git"

  # Github HTTPS with selecting a Specific Release Tag
  #source = "git::https://github.com/stacksimplify/terraform-azurerm-staticwebsitepublic.git?ref=1.0.0"

  # Resource Group
  location = "eastus"
  resource_group_name = "myrg1"

  # Storage Account
  storage_account_name = "staticwebsite"
  storage_account_tier = "Standard"
  storage_account_replication_type = "LRS"
  storage_account_kind = "StorageV2"
  static_website_index_document = "index.html"
  static_website_error_404_document = "error.html"
}
```

## Step-03: Execute Terraform Init and Verify Module download directly via Github
```t
# Terraform Initialize
terraform init

# Verify
cd .terraform
ls
cd modules
ls
cd azure_static_website
ls
cd ../../../

# Clean-Up
rm -rf .terraform*
```

## Step-04: Discuss about various other Terraform Sources
1. Github clone over ssh
```t
module "azure_static_website" {
  source = "git@github.com:stacksimplify/terraform-azurerm-staticwebsitepb.git"
  ... 
  ...  other code
}
```
2. Bitbucket
```t
module "azure_static_website" {
  source = "bitbucket.org/stacksimplify/terraform-azurerm-staticwebsitepb"
  ... 
  ...  other code
}
```
3. Like this many more options we have. Refer [Terraform Modules Sources](https://www.terraform.io/docs/language/modules/sources.html) for detailed documentation

## Step-05: Exam Question
- One question will come from this section for sure.
- Asking us to select the right Terraform Module Source syntax. 