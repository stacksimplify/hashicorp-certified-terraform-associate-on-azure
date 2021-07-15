---
title: Install Terraform, Azure CLI and VSCode Editor
description: Install all the tools required for learning Terraform on Azure Cloud
---

## Step-01: Introduction
- Install [Terraform CLI](https://www.terraform.io/downloads.html)
- Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Install [VS Code Editor](https://code.visualstudio.com/download)
- Install [HashiCorp Terraform plugin for VS Code](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)
- Install [Git Client](https://git-scm.com/downloads)

[![Image](https://stacksimplify.com/course-images/azure-terraform-install-1.png "HashiCorp Certified: Terraform Associate on Azure")](https://stacksimplify.com/course-images/azure-terraform-install-1.png)

## Step-02: MACOS: Terraform Install
- [Download Terraform MAC](https://www.terraform.io/downloads.html)
- [Install CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Unzip the package
```t
# Copy binary zip file to a folder
mkdir /Users/<YOUR-USER>/Documents/terraform-install
COPY Package to "terraform-install" folder

# Unzip
unzip <PACKAGE-NAME>
unzip terraform_0.15.4_darwin_amd64.zip

# Copy terraform binary to /usr/local/bin
echo $PATH
mv terraform /usr/local/bin

# Verify Version
terraform version

# To Uninstall Terraform (NOT REQUIRED)
rm -rf /usr/local/bin/terraform
``` 

## Step-03: MACOS: IDE for Terraform - VS Code Editor
- [Microsoft Visual Studio Code Editor](https://code.visualstudio.com/download)
- [Hashicorp Terraform Plugin for VS Code](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)
- Configure [Course Github Repository](https://github.com/stacksimplify/hashicorp-certified-terraform-associate-on-azure) using VS Code Editor


## Step-04: MACOS: Install Azure CLI
- [Azure CLI Install](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Install Azure CLI - MAC](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos)
```t
# Install XCode
brew update 
xcode-select --install
Observation: Verify images for reference in "image-reference" folder

# Sample Error (Without Xcode if we try az cli install it will through this error)
Error: python@3.8: the bottle needs the Apple Command Line Tools to be installed.
  You can install them, if desired, with:
    xcode-select --install


# AZ CLI Current Version (if installed)
az --version

# Install Azure CLI (if not installed)
brew update 
brew install azure-cli

# Upgrade az cli version
az --version
brew upgrade azure-cli 
[or]
az upgrade
az --version
```

[![Image](https://stacksimplify.com/course-images/xcode-install-1.png "HashiCorp Certified: Terraform Associate on Azure")](https://stacksimplify.com/course-images/xcode-install-1.png)

[![Image](https://stacksimplify.com/course-images/xcode-install-2.png "HashiCorp Certified: Terraform Associate on Azure")](https://stacksimplify.com/course-images/xcode-install-2.png)

[![Image](https://stacksimplify.com/course-images/xcode-install-3.png "HashiCorp Certified: Terraform Associate on Azure")](https://stacksimplify.com/course-images/xcode-install-3.png)

[![Image](https://stacksimplify.com/course-images/xcode-install-4.png "HashiCorp Certified: Terraform Associate on Azure")](https://stacksimplify.com/course-images/xcode-install-4.png)


## Step-05: Terraform - Authenticating using the Azure CLI
- [Azure Provider: Authenticating using the Azure CLI](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli)
```t
# Azure CLI Login
az login

# List Subscriptions
az account list

# Set Specific Subscription (if we have multiple subscriptions)
az account set --subscription="SUBSCRIPTION_ID"
```

## Step-06: Install Git Client
- [Download Git Client](https://git-scm.com/downloads)
- This is required when we are working with `Terraform Modules`

## Step-07: WindowsOS: Terraform & Azure CLI Install
### Step-07-01: Install Git Client
- [Download Git Client](https://git-scm.com/downloads)
- This is required when we are working with `Terraform Modules`

### Step-07-02: Install Azure CLI
- Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli)
- `Step-05:Terraform - Authenticating using the Azure CLI` is going to be same for WindowsOS too. 
```t
# Azure CLI Login
az login

# List Subscriptions
az account list

# Set Specific Subscription (if we have multiple subscriptions)
az account set --subscription="SUBSCRIPTION_ID"
```

### Step-07-03: Install Terraform 
- [Download Terraform](https://www.terraform.io/downloads.html)
- [Install CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Unzip the package
- Create new folder `terraform-bins`
- Copy the `terraform.exe` to a `terraformbins`
- Set PATH in windows 

### Step-07-04: Configure Course Git Repo 
- [Course Git Repo](https://github.com/stacksimplify/hashicorp-certified-terraform-associate-on-azure)
- Shorten Course folder name to smaller one. Put it in C:\ Drive root path

### Step-07-05: Install Visual Studio Code and Terraform Plugin
- [Microsoft Visual Studio Code Editor](https://code.visualstudio.com/download)
- [Hashicorp Terraform Plugin for VS Code](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)
- Configure [Course Github Repository](https://github.com/stacksimplify/hashicorp-certified-terraform-associate-on-azure) using VS Code Editor

### Step-07-06: WindowsOS: Long Path Issues for Terraform CLI
- [Windows10 Long File Name or Path](https://github.com/hashicorp/terraform/issues/21173)
- [Microsoft fix](https://answers.microsoft.com/en-us/windows/forum/all/windows-10-commands-with-long-path-name-are-not/13f0f7c7-d55c-4c6c-b19d-9dfec099dd45)
- Our fix is to shorten our git repo names to see if that helps

## Step-08: LinuxOS: Terraform & Azure CLI Install
- [Download Terraform](https://www.terraform.io/downloads.html)
- [Linux OS - Terraform Install](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=script)
- `Step-05:Terraform - Authenticating using the Azure CLI` is going to be same for LinuxOS too. 
- [Course Git Repo](https://github.com/stacksimplify/hashicorp-certified-terraform-associate-on-azure)