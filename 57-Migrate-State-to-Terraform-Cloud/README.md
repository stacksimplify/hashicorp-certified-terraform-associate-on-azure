---
title: Migrate State to Terraform Cloud
description: Learn about migrating State to Terraform Cloud
---

## Step-01: Introduction
- We are going to migrate State to Terraform Cloud

## Step-02: Review Terraform Manifests
1. c1-versions.tf
2. c2-variables.tf
3. c3-static-website.tf
4. c4-outputs.tf

## Step-03: Execute Terraform Commands (First provision using local backend)
- First provision infra using local backend
- `terraform.tfstate` file will be created in local working directory
- In next steps, migrate it to Terraform Cloud
```t
# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

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

## Step-04: Review your local state file
-  Review your local `terraform.tfstate` file once


## Step-05: Update remote backend in c1-versions.tf Terraform Block
```t
# Template
  backend "remote" {
    hostname      = "app.terraform.io"
    organization  = "<YOUR-ORG-NAME>"

    workspaces {
      name = "<SOME-NAME>"
    }
  }

# Replace Values
  backend "remote" {
    hostname      = "app.terraform.io"
    organization  = "hcta-azure-demo1"  # Organization should already exists in Terraform Cloud

    workspaces {
      name = "state-migration-demo1" 
      # Two cases: 
      # Case-1: If workspace already exists, should not have any state files in states tab
      # Case-2: If workspace not exists, during migration it will get created
    }
  }
```


## Step-06: Migrate State file to Terraform Cloud and Verify
```t
# Terraform Login
terraform login
Observation: 
1) Should see message |Success! Terraform has obtained and saved an API token.|
2) Verify Terraform credentials file
cat /Users/<YOUR_USER>/.terraform.d/credentials.tfrc.json
cat /Users/kdaida/.terraform.d/credentials.tfrc.json
Additional Reference:
https://www.terraform.io/docs/cli/config/config-file.html#credentials-1
https://www.terraform.io/docs/cloud/registry/using.html#configuration

# Terraform Initialize
terraform init
Observation: 
1) During reinitialization, Terraform presents a prompt saying that it will copy the state file to the new backend. 
2) Enter yes and Terraform will migrate the state from your local machine to Terraform Cloud.

## Sample Output
Kalyans-Mac-mini:terraform-manifests kalyanreddy$ terraform init

Initializing the backend...
Acquiring state lock. This may take a few moments...
Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "remote" backend. No existing state was found in the newly
  configured "remote" backend. Do you want to copy this state to the new "remote"
  backend? Enter "yes" to copy and "no" to start with an empty state.

  Enter a value: yes
Successfully configured the backend "remote"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Reusing previous version of hashicorp/null from the dependency lock file
- Reusing previous version of hashicorp/azurerm from the dependency lock file
- Reusing previous version of hashicorp/random from the dependency lock file
- Using previously-installed hashicorp/azurerm v2.63.0
- Using previously-installed hashicorp/random v3.1.0
- Using previously-installed hashicorp/null v3.1.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
Kalyans-Mac-mini:terraform-manifests kalyanreddy$ 


# Verify in Terraform Cloud
1) New workspace should be created with name "state-migration-demo1"
2) Verify "states" tab in workspace, we should find the state file
```

## Step-07: Terraform Cloud to Authenticate to Azure using Service Principal with a Client Secret
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

## Step-08: Configure Environment Variables in Terraform Cloud
- Go to Organization -> hcta-azure-demo1 -> Workspace ->  state-migration-demo1 -> Variables
- Add Environment Variables listed below
```t
ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```
 
## Step-08: Delete local terraform.tfstate
- First take backup and put it safe and delete it
```t
# Take backup
cp terraform.tfstate terraform.tfstate_local

# Delete
rm terraform.tfstate
``` 

## Step-09: Apply a new run from Terraform CLI
- Make a change and do  `terraform apply`
```t
# Add new resource (c3-static-website.tf)
# Create New Resource Group
resource "azurerm_resource_group" "resource_group2" {
  name     = "myrg2021"
  location = "eastus"
}

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply 

# Verify in Terraform Cloud
1) Verify in Runs Tab in TF Cloud
2) Verify States Tab in TF Cloud
```

## Step-10: Destroy & Clean-Up
-  Destroy Resources from cloud this time instead of `terraform destroy` command
- Go to Organization (hcta-azure-demo1) -> Workspace(state-migration-demo1) -> Settings -> Destruction and Deletion
- Click on **Queue Destroy Plan**
```t
# Clean-Up files
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## Step-11: Rollback changes for Students seamless demo
```t
# Change-1: c1-versions.tf
- Comment "backend" block which will be enabled during step-05
# Change-2: c3-static-website.tf
- Comment "new Resource Group Resource" block which will be enabled during step-09
```
