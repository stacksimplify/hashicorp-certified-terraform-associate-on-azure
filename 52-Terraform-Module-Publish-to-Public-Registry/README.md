---
title: Terraform Module Publish to Terraform Public Registry
description: Learn Terraform Module Publish to Terraform Public Registry
---

## Step-01: Introduction
- Create and version a GitHub repository for Terraform Modules
- Publish Module to Terraform Public Registry
- Construct a root module to consume modules from the Terraform Public Registry.
- Understand about Terraform Module Versioning. 

## Step-02: Create new github Repository for azure-static-website terraform module
- **URL:** github.com
- Click on **Create a new repository**
- Follow Naming Conventions for modules
  - terraform-PROVIDER-MODULE_NAME
  - **Sample:** terraform-azurerm-staticwebsitepublic
- **Repository Name:** terraform-azurerm-staticwebsitepublic
- **Description:** Terraform Modules to be shared in Terraform Public Registry
- **Repo Type:** Public 
- **Initialize this repository with:**
- **UN-CHECK** - Add a README file
- **CHECK** - Add .gitignore 
- **Select .gitignore Template:** Terraform
- **CHECK** - Choose a license
- **Select License:** Apache 2.0 License  (Optional)
- Click on **Create repository**

## Step-03: Clone Github Repository to Local Desktop
```t
# Clone Github Repo
git clone https://github.com/<YOUR_GITHUB_ID>/<YOUR_REPO>.git
git clone https://github.com/stacksimplify/terraform-azurerm-staticwebsitepublic.git
```

## Step-04: Copy files from terraform-manifests to local repo & Check-In Code
- **Source Location from this section:** terraform-azure-static-website-module-manifests
- **Destination Location:** Newly cloned github repository folder in your local desktop `terraform-azurerm-staticwebsitepublic`
- Check-In code to Remote Repository
```t
# GIT Status
git status

# Git Local Commit
git add .
git commit -am "TF Module Files First Commit"

# Push to Remote Repository
git push

# Verify the same on Remote Repository
https://github.com/stacksimplify/terraform-azurerm-staticwebsitepublic.git
```


## Step-05: Create New Release Tag 1.0.0 in Repo
- Go to Right Navigation on github Repo -> Releases -> Create a new release
- **Tag Version:** 1.0.0
- **Release Title:** Release-1 terraform-azurerm-staticwebsitepublic
- **Write:** Terraform Module for Public Registry - terraform-azurerm-staticwebsitepublic
- Click on **Publish Release**

## Step-06: Publish Module to Public Terraform Registry
- Access URL: https://registry.terraform.io/
- Sign-In using your Github Account.
- Authorize the Terraform Registry when prompted.
- Goto -> Publish -> Modules
- **Select Repository on GitHub:** terraform-azurerm-staticwebsitepublic
- Check `I agree to the Terms of Use`
- Click on **Publish Module**

## Step-07: Review the newly Published Module
- **URL:** https://registry.terraform.io/modules/stacksimplify/staticwebsitepublic/azurerm/latest
- Review the Module Tabs on Terraform Cloud
1. Readme
2. Inputs
3. Outputs
4. Dependencies
5. Resources
- Also review the following
1. Versions
2. Provision Instructions   

## Step-08: Review Root Module Terraform Configs
- We have copied `terraform-manifests` from previous section `51-Terraform-Modules-Build-Local-Module`
- Here instead of using local re-usable module, we are going to use the Module source from Terraform Public Registry for the module which we recently published.
- **c3-static-website.tf**
- Commented `source` local module reference
- Added `source` and `version` from Terraform Public Registry
```t
# Call our Custom Terraform Module which we built earlier
module "azure_static_website" {
  #source = "./modules/azure-static-website"  
  source  = "stacksimplify/staticwebsitepublic/azurerm"
  version = "1.0.0"

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

## Step-09: Execute Terraform Commands
```t
# Terraform Initialize
terraform init
Observation: 
1. Should pass and download modules and providers

# Sample Output for reference
Initializing modules...
Downloading stacksimplify/staticwebsitepublic/azurerm 1.0.0 for azure_static_website...
- azure_static_website in .terraform/modules/azure_static_website

# Terraform Validate
terraform validate

# Terraform Format
terraform fmt

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-approve

# Upload Static Content
1. Go to Storage Accounts -> staticwebsitexxxxxx -> Containers -> $web
2. Upload files from folder "static-content"


# Verify 
1. Azure Storage Account created
2. Static Website Setting enabled
3. Verify the Static Content Upload Successful
4. Access Static Website
https://staticwebsitek123.z13.web.core.windows.net/
```


## Step-10: Destroy and Clean-Up
```t
# Terraform Destroy
terraform destroy -auto-approve

# Delete Terraform files 
rm -rf .terraform*
rm -rf terraform.tfstate*
```


## Step-11: Module Management on Terraform Public Registry
- URL: https://registry.terraform.io/modules/stacksimplify/staticwebsitepublic/azurerm/latest
- You should be logged in to `Terraform Public Registry` with your github account with which you published this module.
1. Resync Module
2. Delete Module Version
3. Delete Module Provider
4. Delete Module

## Step-12: Module Versioning
1. Make changes to your module code and push changes to Git Repo
2. On Git Repo, create a new release tag `example: 2.0.0`
3. Verify the same in Terraform Registry
```t
# Local Git Repo
Just change Readme.md file
Add text `- Version 2.0.0`

# Git Commands
git status
git commit -am "2.0.0 Commit"
git push

# Draft New Release
1. Go to Right Navigation on github Repo -> Releases -> Draft a new release
2. Tag Version: 2.0.0
3. Release Title: Release-2 terraform-azurerm-staticwebsitepublic
4. Write: Terraform Module for Public Registry - terraform-azurerm-staticwebsitepublic Release-2
5. Click on "Publish Release"

# Verify
https://registry.terraform.io/modules/stacksimplify/staticwebsitepublic/azurerm/latest
In Versions drop-down, you should notice 1.0.0 and 2.0.0(latest) tags

# Update your Module Version tag to use new version of Module
c3-static-website.tf
Old: version = "1.0.0"
New:   version = "2.0.0"
```

