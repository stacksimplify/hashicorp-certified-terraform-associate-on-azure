---
title: Terraform Cloud - CLI-Driven Workflow
description: Learn about Terraform Cloud - CLI-Driven Workflow
---

## Step-01: Introduction
- Learn and practically implement `CLI-Driven Workflow` in Terraform Cloud

## Step-02: Review Terraform Configuration Files
- c1-versions.tf
- c2-variables.tf
- c3-static-website.tf
- c4-outputs.tf

## Step-03: Create Workspace with CLI Driven Workflow
- Login to [Terraform Cloud](https://app.terraform.io/)
- Select Organization -> hcta-azure-demo1
- Click on **New Workspace**
- **Choose your workflow:** CLI-Driven Workflow
- **Workspace Name:** cli-driven-azure-demo
- **Workspace Description:** Terraform Cloud CLI Driven Workflow Azure Demo
- Click on **Create Workspace**

## Step-04: Add backend block in Terraform Settings c1-versions.tf
```t
terraform {
  backend "remote" {
    organization = "hcta-azure-demo1"

    workspaces {
      name = "cli-driven-azure-demo"
    }
  }
}
```

## Step-05: Verify c3-static-website.tf
```t
# Before
  source  = "app.terraform.io/hcta-azure-demo1/staticwebsiteprivate/azurerm"
# After
  source  = "app.terraform.io/<YOUR_ORGANIZATION>/<YOUR_MODULE_NAME_IF_DIFFERENT>/azurerm"
  source  = "app.terraform.io/<YOUR_ORGANIZATION>/staticwebsitepr/azurerm"   
```

## Step-06: Execute Terraform Commands
```t
# Terraform Login
terraform login
Token Name: clidemoapitoken1
Token value: wtMhS66BJORvLg.atlasv1.GzmOyLo8ih9RDP3j6zXMLjBB0lyIYKiLo8Mu7aSYvfwCmu1X6pIBWh0y1ZJziYgQU2c
Observation: 
1) Should see message |Retrieved token for user stacksimplify
2) Verify Terraform credentials file
cat /Users/<YOUR_USER>/.terraform.d/credentials.tfrc.json
cat /Users/kdaida/.terraform.d/credentials.tfrc.json
Additional Reference:
https://www.terraform.io/docs/cli/config/config-file.html#credentials-1
https://www.terraform.io/docs/cloud/registry/using.html#configuration

# Terraform Initialize
terraform init
Observation: 
1. Should pass and download Private Registry modules from Terraform Cloud and providers
2. Verify Private Registry module downloaded. 

# Terraform Validate
terraform validate

# Terraform Format
terraform fmt

# Terraform Plan
terraform plan
Observation: 
1. Should fail with error due to Azure Provider credential configuration not done on Terraform Cloud for this respective workspace

# Sample Output
Initializing Terraform configuration...
╷
│ Error: Error building AzureRM Client: obtain subscription() from Azure CLI: Error parsing json result from the Azure CLI: Error waiting for the Azure CLI: exit status 1: ERROR: Please run 'az login' to setup account.
│ 
│   with module.azure_static_website.provider["registry.terraform.io/hashicorp/azurerm"],
│   on .terraform/modules/azure_static_website/main.tf line 2, in provider "azurerm":
│    2: provider "azurerm" {

```


## Step-08: Terraform Cloud to Authenticate to Azure using Service Principal with a Client Secret
- [Azure Provider: Authenticating using a Service Principal with a Client Secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret) 
```t
# Azure CLI Login
az login

# Azure Account List
az account list
Observation:
1. Make a note of the value whose key is "id" which is nothing but your "subscription_id"

# Set Subscription ID
az account set --subscription="SUBSCRIPTION_ID"
az account set --subscription="82808767-144c-4c66-a320-b30791668b0a"

# Create Service Principal & Client Secret
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID"
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/82808767-144c-4c66-a320-b30791668b0a"

# Sample Output
{
  "appId": "99a2bb50-e5a1-4d72-acd3-e4697ecb5308",
  "displayName": "azure-cli-2021-06-15-15-41-54",
  "name": "http://azure-cli-2021-06-15-15-41-54",
  "password": "0ed3ZeK0DijKvhat~a5NnaQ_bpG_uv_-Xh",
  "tenant": "c81f465b-99f9-42d3-a169-8082d61c677a"
}

# Observation
"appId" is the "client_id" defined above.
"password" is the "client_secret" defined above.
"tenant" is the "tenant_id" defined above.

# Verify
az login --service-principal -u CLIENT_ID -p CLIENT_SECRET --tenant TENANT_ID
az login --service-principal -u 99a2bb50-e5a1-4d72-acd3-e4697ecb5308 -p 0ed3ZeK0DijKvhat~a5NnaQ_bpG_uv_-Xh --tenant c81f465b-99f9-42d3-a169-8082d61c677a
az account list-locations -o table
az logout
```

## Step-09: Configure Environment Variables in Terraform Cloud
- Go to Organization -> hcta-azure-demo1 -> Workspace ->  cli-driven-azure-demo -> Variables
- Add Environment Variables listed below
```t
ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```


## Step-10: Execute Terraform Commands
```t
# Terraform Plan
terraform plan
Observation: 
1. Open Plan using link specified in CLI output
Example: https://app.terraform.io/app/hcta-azure-demo1-internal/cli-driven-azure-demo/runs/run-XNpEAoCPCQQSaqb3
2. Terraform plan should pass now. 


# Terraform Apply
terraform apply 
Observation:
1. Go to Terraform Cloud -> Organization: hcta-azure-demo1 -> Workspace: cli-driven-azure-demo -> Runs Tab
2. Review the plan
3. Provide confirmation "yes" in Terraform CLI (Terminal)
4. Observe TF Cloud Runs tab

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



## Step-11: Verify the following
- Select Organization -> hcta-azure-demo1
- **Workspace Name:** cli-driven-azure-demo
- Runs
- States
```t
# Key Observation
1. Running the Terraform Commands on your local desktop but they are running on Terraform Cloud and you can see the same in Runs
2. State is also maintained in Terraform Cloud. 
```

## Step-12: Destroy and Clean-Up
```t
# Terraform Destroy
terraform destroy 

# Delete Terraform files 
rm -rf .terraform*
```

## Additional References
- [CLI Configuration File](https://www.terraform.io/docs/cli/config/config-file.html#credentials)