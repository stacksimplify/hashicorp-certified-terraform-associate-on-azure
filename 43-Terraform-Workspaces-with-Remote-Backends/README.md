---
title: Terraform Workspaces with Remote Backend
description: Learn Terraform Workspaces with Remote Backend
---

## Step-01: Introduction
- We are going to use Terraform Remote Backend (Azure Storage)
- We are going to create 3 workspaces (default, dev, staging, prod) in addition to default workspace
- We will understand how the Terraform TF State Files get created in Azure Storage Account as part of multiple workspaces concept.

## Step-02: c1-versions.tf
- Add Backend block in Terraform Settings block
```t
# Terraform State Storage to Azure Storage Container
  backend "azurerm" {
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformstate201"
    container_name        = "tfstatefiles"
    key                   = "cliworkspaces-terraform.tfstate"
  }   
```

## Step-03: Create Workspaces and Verify State files in Storage Account
```t
# Terraform Init
terraform init 
Observation:
1. Go to Azure Management Console -> terraform-storage-tg -> terraformstate201 -> tfstatefiles
2. Verify file with name "cliworkspaces-terraform.tfstate"
3. Verify file size (Approx 155B)

# List Workspaces
terraform workspace list

# Output Current Workspace using show
terraform workspace show

# Create Workspaces
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod

# Verify the workspace file names in Storage Account
cliworkspaces-terraform.tfstate:dev
cliworkspaces-terraform.tfstate:staging
cliworkspaces-terraform.tfstate:prod

# Delete Workspaces
terraform workspace select default
terraform workspace delete dev
terraform workspace delete staging
terraform workspace delete prod

# Verify the workspace file names in Storage Account
Observation:
1. All the workspace specific state files should be deleted automatically when workspaces get deleted.
2. Only `cliworkspaces-terraform.tfstate` default worksapce file should be present because we will not be able to delete default workspace. 
```

## Step-04: Clean-Up Local folder
```t
# Clean-Up local folder
rm -rf .terraform*
```

## References
- [Terraform Workspaces](https://www.terraform.io/docs/language/state/workspaces.html)
- [Managing Workspaces](https://www.terraform.io/docs/cli/workspaces/index.html)