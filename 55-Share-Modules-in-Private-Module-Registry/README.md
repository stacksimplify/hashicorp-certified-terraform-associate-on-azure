---
title: Share Terraform Modules in Private Modules Registry
description: Learn about sharing Modules in Private Modules Registry
---
## Step-01: Introduction
- Create and version a GitHub repository for use in the private module registry
- Import a module into your organization's private module registry.
- Construct a root module to consume modules from the private registry.
- Over the process also learn about `terraform login` command

## Step-02: Create new private github Repository for Azure Static Website terraform module
- **URL:** github.com
- Click on **Create a new repository**
- Follow Naming Conventions for modules
  - terraform-PROVIDER-MODULE_NAME
  - **Sample:** terraform-azurerm-staticwebsiteprivate
- **Repository Name:** terraform-azurerm-staticwebsiteprivate
- **Description:** Terraform Modules to be shared in Private Registry
- **Repo Type:** Private  (I will make this repo public for students to access it after the demo)
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
git clone https://github.com/stacksimplify/terraform-azurerm-staticwebsiteprivate.git
```

## Step-04: Copy files from terraform-manifests to local repo & Check-In Code
- **Source Location from this section:** terraform-azure-static-website-module-manifests
- **Destination Location:** Newly cloned github repository folder in your local desktop `terraform-azurerm-staticwebsiteprivate`
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
https://github.com/stacksimplify/terraform-azurerm-staticwebsiteprivate.git
```

## Step-05: Create New Release Tag 1.0.0 in Repo
- Go to Right Navigation on github Repo -> Releases -> Create a new release
- **Tag Version:** 1.0.0
- **Release Title:** Release-1 terraform-azure-staticwebsiteprivate
- **Write:** Terraform Module for Private Registry on Terraform Cloud - terraform-azure-staticwebsiteprivate
- Click on **Publish Release**


## Step-06: Add VCS Provider as Github using OAuth App in Terraform Cloud 

### Step-06-01: Add VCS Provider as Github using OAuth App in Terraform Cloud
- Login to Terraform Cloud
- Go to -> Organization `hcta-azure-demo1` -> Registry Tab
- Click on Publish Private Module  -> Select Github(Custom)
- Option-1: Should redirect to URL: https://github.com/settings/applications/new in new browser tab (None Configured)
- Option-2: If already one or more OAuth Apps configured with that Github Account Click on `register a new OAuth Application` and it should redirect to URL: https://github.com/settings/applications/new
- **Application Name:** Terraform Cloud (hctaazuredemo1) 
- **Homepage URL:**	https://app.terraform.io 
- **Application description:**	Terraform Cloud Integration with Github using OAuth 
- **Authorization callback URL:**	https://app.terraform.io/auth/358abc4a-c3c9-4c49-9ddd-354d75d6fe85/callback
- Click on **Register Application**
- Make a note of Client ID: ad55bce90463ff34bb56 (Sample for reference)
- Generate new Client Secret: ff3e6a4343cad08694ddfa3bfd0bd50c429f941a

### Step-06-02: Add the below in Terraform Cloud
- Name: github-terraform-modules-for-azure
- Client ID: ad55bce90463ff34bb56
- Client Secret: ff3e6a4343cad08694ddfa3bfd0bd50c429f941a
- Click on **Connect and Continue**
- Authorize Terraform Cloud (hctaazuredemo1) - Click on **Authorize StackSimplify**
- SSH Keypair (Optional): click on **Skip and Finish**

### Step-06: Import the Terraform Module from Github
- In above step, we have completed the VCS Setup with github
- Now lets go ahead and import the Terraform module from Github
- Login to Terraform Cloud
- Go to -> Organization `hcta-azure-demo1` -> Registry Tab
- Click on Publish Private Module  -> Select Github (github-terraform-modules-for-azure)
(PRE-POPULATED) -> Select it
- **Choose a Repository:** terraform-azurerm-staticwebsiteprivate
- Click on **Publish Module**

## Step-07: Review newly imported Module
- Login to Terraform Cloud -> Click on Modules Tab 
- Review the Module Tabs on Terraform Cloud
1. Readme
2. Inputs
3. Outputs
4. Dependencies
5. Resources
- Also review the following
1. Versions
2. Provision Instructions   

## Step-08: Create a configuration that uses the Private Registry module using Terraform CLI
- CreateTerraform Configuration in Root Module by calling the newly published module in Terraform Private Registry
- c3-static-website.tf
```t
# Call our Custom Terraform Module which we built earlier
module "azure_static_website" {
  #source = "./modules/azure-static-website"  
  #source  = "stacksimplify/staticwebsitepb/azurerm"
  source  = "app.terraform.io/hcta-azure-demo1-internal/staticwebsiteprivate/azurerm"
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
# Change Directory 
cd 55-Share-Modules-in-Private-Module-Registry/terraform-manifests

# Terraform Initialize
terraform init
Observation: 
1. Should fail with error due to cli not having access to Private module registry in Terraform Cloud

## Sample Output
Kalyans-Mac-mini:terraform-manifests kalyanreddy$ terraform init
Initializing modules...
╷
│ Error: Error accessing remote module registry
│ 
│ Failed to retrieve available versions for module "azure_static_website" (c3-static-website.tf:2)
│ from app.terraform.io: error looking up module versions: 401 Unauthorized.


# Terraform Login
terraform login
Token Name: terraformlogincli3
Token value: 3nr7c3o24tOMfw.atlasv1.ruqdwL6iOkd49Bv0yCfIdC0V3h21vWKil4tby3DyhjurSByRF27cMSDhi6rEboVRiY8
Observation: 
1) Should see message |Retrieved token for user stacksimplify
2) Verify Terraform credentials file
cat /Users/<YOUR_USER>/.terraform.d/credentials.tfrc.json
cat /Users/kdaida/.terraform.d/credentials.tfrc.json
Additional Reference:
https://www.terraform.io/docs/cli/config/config-file.html#credentials-1
https://www.terraform.io/docs/cloud/registry/using.html#configuration

## Sample Output
Kalyans-Mac-mini:terraform-manifests kalyanreddy$ cat /Users/kalyanreddy/.terraform.d/credentials.tfrc.json 
{
  "credentials": {
    "app.terraform.io": {
      "token": "3nr7c3o24tOMfw.atlasv1.ruqdwL6iOkd49Bv0yCfIdC0V3h21vWKil4tby3DyhjurSByRF27cMSDhi6rEboVRiY8"
    }
  }
}Kalyans-Mac-mini:terraform-manifests kalyanreddy$ 


# Terraform Initialize
terraform init
Observation: 
1. Should pass and download modules and providers
2. Verify the private registry module got downloaded

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

## Step-09: Create a configuration that uses the Private Registry module using Terraform Cloud & Github
### Assignment
1. Create Github Repository
2. Check-In files from `terraform-manifests` folder in `55-Share-Modules-in-Private-Module-Registry` section
3. Create a new Workspace with VCS workflow in Terraform Cloud to connect with Github Repository
4. Execute `Queue Plan` to apply the changes and test


## Step-10: VCS Providers & Terraform Cloud
- [Configuration-Free GitHub Usage](https://www.terraform.io/docs/cloud/vcs/github-app.html)
- [Configuring GitHub.com Access (OAuth)](https://www.terraform.io/docs/cloud/vcs/github.html)
- [Configuring GitHub Enterprise Access](https://www.terraform.io/docs/cloud/vcs/github-enterprise.html)
- [Other Supported VCS Providers](https://www.terraform.io/docs/cloud/vcs/index.html)

