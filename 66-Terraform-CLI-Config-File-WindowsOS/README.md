---
title: Terraform CLI Config File Windows OS
description: Learn about Terraform CLI Config File Windows OS 
---


## Step-01: Introduction
- [Terraform CLI Config File](https://www.terraform.io/docs/cli/config/config-file.html)
- Understand about `Terraform CLI Config File` 
1. Windows: terraform.rc

## Step-02: Create terraform.rc in User Home Directory
- On Windows, the file must be named terraform.rc and placed in the relevant user's `%APPDATA%` directory. 
- The physical location of this directory depends on your Windows version and system configuration; use `$env:APPDATA` in PowerShell to find its location on your system.
- On Windows, beware of Windows Explorer's default behavior of hiding filename extensions. 
- Terraform will not recognize a file named `terraform.rc.txt` as a CLI configuration file, even though Windows Explorer may display its name as just `terraform.rc`. 
- Use `dir` from `PowerShell` or `Command Prompt` to confirm the filename.
```t
# Find location where we need to put terraform.rc using Powershell
$env:APPDATA

# Create a Folder in C:\ Drive (C:\Users\Administrator\Documents\)
Folder Name: plugin_cache
```

## Step-03: Update terraform.rc with Plugin Cache Folder
```t
plugin_cache_dir = "C:/Users/Administrator/Documents/plugin_cache"
disable_checkpoint = true
```

## Step-04: Execute Terraform Commands
```t
# Change Directory 
cd 66-Terraform-CLI-Config-File-WindowsOS/terraform-manifests

# Terraform Initialize
terraform init

# Verify the contents in Plugin Cache Directory
C:\Users\Administrator\Documents\plugin_cache
C:\Users\Administrator\Documents\plugin_cache\registry.terraform.io\hashicorp
```

## Step-05: Verify if plugins loaded from Cache
```t
# Change Directory 
cd 66-Terraform-CLI-Config-File-WindowsOS/terraform-manifests

# Remove .terraform Folder which contains plugins
Delete folder .terraform

# Terraform Initialize
terraform init

# Sample Output for Reference
PS C:\Users\Administrator\Downloads\hashicorp-certified-terraform-associate-on-azure-main\hashicorp-certified-terraform-associate-on-azure-main\66-Terraform-CLI-Config-File-WindowsOS\terraform-manifests> terraform init

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/external versions matching ">= 2.0.0"...
- Finding hashicorp/azurerm versions matching ">= 2.0.0"...
- Finding hashicorp/random versions matching ">= 3.0.0"...
- Using hashicorp/random v3.1.0 from the shared cache directory
- Using hashicorp/external v2.1.0 from the shared cache directory
- Using hashicorp/azurerm v2.65.0 from the shared cache directory
```

## Step-07: Clean-Up
```t
# Remove .terraform Folder which contains plugins
Delete folder .terraform and file: .terraform.lock.hcl
```

