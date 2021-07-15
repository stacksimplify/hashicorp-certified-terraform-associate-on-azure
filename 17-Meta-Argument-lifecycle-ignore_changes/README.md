---
title: Terraform Meta-Argument lifecycle ignore_changes
description: Learn Terraform Resource Meta-Argument lifecycle ignore_changes
---

## Step-01: Introduction
- lifecyle Meta-Argument block contains 3 arguments
1. create_before_destroy
2. prevent_destroy
3. ignore_changes
- We are going to practically understand and implement `ignore_changes`  

## Step-02: Review Terraform Manifests
- c1-versions.tf
- c2-resource-group.tf
- c3-virtual-network.tf

## Step-03: Create a Azure Virtual Network, make manual changes and understand the behavior
- Create Azure Virtual Network
```t
# Switch to Working Directory
cd terraform-manifests

# Initialize Terraform
terraform init

# Terraform Validate
terraform validate

# Terraform Plan 
terraform plan

# Terraform Apply 
terraform apply 
```
## Step-04: Update the tag by going to Azure management console
- Add a new tag manually to Azure Virtual Network Resource
- Try `terraform apply` now
- Terraform will find the difference in configuration on remote side when compare to local and tries to remove the manual change when we execute `terraform apply`
```t
# Add new tag manually using Azure Portal
WebServer = Apache

# Terraform Plan 
terraform plan

# Terraform Apply 
terraform apply 
Observation: 
1) It will remove the changes which we manually added using Azure Management console
```

## Step-05: Add the lifecyle - ignore_changes block
- Enable the block in `c3-virtual-network.tf`
```t
# Lifecycle Block
   lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }
```
- Add new tags manually using Azure Management console for Azure Virtual Network Resource
```t
# Add new tag manually
WebServer = Apache2
ignorechanges = test1

# Terraform Plan 
terraform plan

# Terraform Apply 
terraform apply 
Observation: 
1) Manual changes should not be touched. They should be ignored by terraform
2) Verify the same on Azure management console
```

## Step-06: Lets see the downside of this Lifecycle Block
- Add new tag from Terraform Configs by editing the `c3-virtual-network.tf`
```t
# Terraform Plan
terraform plan
Observation:
1. "No changes" will be reported as we cannot add new tag because it is present in ignore_changes lifecycle block

# Terraform Apply
terraform apply
Observation:
1. "No changes" will be reported as we cannot add new tag because it is present in ignore_changes lifecycle block
```

## Step-07: Clean-Up
```t
# Destroy Resource
terraform destroy -auto-approve

# Clean-Up
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## References
- [Resource Meat-Argument: Lifecycle](https://www.terraform.io/docs/language/meta-arguments/lifecycle.html)