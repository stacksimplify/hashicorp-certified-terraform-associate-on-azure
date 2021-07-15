---
title: Terraform CLI Config File MacOS and LinuxOS
description: Learn about Terraform CLI Config File MacOS and LinuxOS
---

## Step-01: Introduction
- [Terraform CLI Config File](https://www.terraform.io/docs/cli/config/config-file.html)
- Understand about `Terraform CLI Config File` 
1. Windows: terraform.rc
2. Linux, MacOS: .terraformrc
- Understand about `plugin_cache_dir`

## Step-02: Create .terraformrc in User Home Directory
```t
# Change Directory
cd $HOME

# Create Terraform CLI Config File
touch .terraformrc
```

## Step-03: Update .terraformrc with Plugin Cache Folder
```t
# Update File
vi $HOME/.terraformrc

plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"
disable_checkpoint = true

# Create Directory
mkdir -p $HOME/.terraform.d/plugin-cache
```

## Step-04: Execute Terraform Commands
```t
# Change Directory 
cd 65-Terraform-CLI-Config-File-MacOS-and-Linux/terraform-manifests

# Terraform Initialize
terraform init

# Verify the contents in Plugin Cache Directory
ls -lrta $HOME/.terraform.d/plugin-cache
cd $HOME/.terraform.d/plugin-cache
ls
cd $HOME/.terraform.d/plugin-cache/registry.terraform.io/hashicorp/
ls
```

## Step-05: Verify if plugins loaded from Cache

```t
# Change Directory 
cd 65-Terraform-CLI-Config-File-MacOS-and-Linux/terraform-manifests

# Remove .terraform Folder which contains plugins
rm -rf .terraform*

# Terraform Initialize
terraform init

# Sample Output for Reference
Kalyans-Mac-mini:terraform-manifests kalyanreddy$ terraform init
Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/azurerm versions matching ">= 2.0.0"...
- Finding hashicorp/random versions matching ">= 3.0.0"...
- Finding hashicorp/external versions matching ">= 2.0.0"...
- Using hashicorp/random v3.1.0 from the shared cache directory
- Using hashicorp/external v2.1.0 from the shared cache directory
- Using hashicorp/azurerm v2.65.0 from the shared cache directory

# Observation
1. You can see provider plugins downloaded from "shared cache directory"
```

## Step-07: Clean-Up
```t
# Remove .terraform Folder which contains plugins
rm -rf .terraform*
```

## Step-08: Terraform Cloud Credentials
- You can define Terraform Cloud Credentials globally using `.terraformrc` file in your `$HOME` directroy with a `token`
- [Terraform Cloud Credentials](https://www.terraform.io/docs/cli/config/config-file.html#credentials-1)
```t
credentials "app.terraform.io" {
  token = "xxxxxx.atlasv1.zzzzzzzzzzzzz"
}
```