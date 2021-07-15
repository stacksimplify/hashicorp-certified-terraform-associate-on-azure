---
title: Azure Terraform VSCode Extension
description: Explore Terraform Azure VSCode Extension
---

## Pre-requisite: Configure Azure Cloud Shell
- Configure Azure Cloud Shell.

## Step-01: Introduction
- For students, who have difficulty in running in local desktops (windows or mac), they can use this plugin to run on Azure Cloud Shell.
- Learn about [Azure Terraform VSCode Extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azureterraform)

## Step-02: Install graphviz
- [Graphviz](https://graphviz.org/download/)
```t
# Install Graphviz
brew install graphviz
```

## Step-03: Install NodeJS
- [Download NodeJs Package](https://nodejs.org/en/)
- Install the Package

## Step-04: Install the Azure Terraform Visual Studio Code extension
- [Azure Terraform VSCode Extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azureterraform)
- The features in this extension support execution in integrated terminal mode or remotely using Azure Cloud Shell. 
- Some features only run locally at this time and will require some local dependencies.
1. Azure Terraform: init
2. Azure Terraform: plan
3. Azure Terraform: apply
4. Azure Terraform: validate
5. Azure Terraform: refresh
6. Azure Terraform: destroy
7. Azure Terraform: visualize	
8. Azure Terraform: push	
9. Azure Terraform: Execute Test	

## Step-05: VS Code - Integrated Terminal: Run Commands Terraform init, plan, apply, visualize
- Update VS Code Settings -> Extensions -> Azure Terraform -> Azure Terraform: Terminal -> Integrated 
- Open `06-Azure-Terraform-VsCode-Plugin/terraform-manifests` in a new vscode window. 
- Test the following commands (CMD + SHIFT + P)
1. Azure Terraform: init
2. Azure Terraform: validate
3. Azure Terraform: plan
4. Azure Terraform: apply
5. Azure Terraform: destroy
6. Azure Terraform: visualize
- Review the `Terraform Graph`	

## Step-06: VS Code - CloudShell Terminal: Run Commands Terraform init, plan, apply, visualize
- Create CloudShell storage if not created or not accessed Cloudshell for the first time. 
- Update VS Code Settings -> Extensions -> Azure Terraform -> Azure Terraform: Terminal -> CloudShell 
- Open `06-Azure-Terraform-VsCode-Plugin/terraform-manifests` in a new vscode window. 
- Test the following commands
1. Azure Terraform: Push
2. Azure Terraform: init
3. Azure Terraform: validate
4. Azure Terraform: plan
5. Azure Terraform: apply
6. Azure Terraform: destroy
- Make change to `c1-versions.tf` and run `Azure Terraform: Push`  command and Verify in Azure cloudshell
1. Azure Terraform: Push
2. Azure Terraform: plan


## Step-06: Clean-up
```t
# Clean-Up files (if any exists of below type)
rm -rf .terraform*
rm -rf terraform.tfstate
```



## References
- [Azure Terraform Visual Studio Code extension](https://docs.microsoft.com/en-us/azure/developer/terraform/configure-vs-code-extension-for-terraform)
- [Terraform Graph](https://graphviz.org/download/)