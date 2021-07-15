---
title: Terraform Cloud & Github Integration
description: Learn more about Terraform Cloud & Github Integration
---

## Step-01: Introduction
- Create Github Repository on github.com
- Clone Github Repository to local desktop
- Copy & Check-In Terraform Configurations in to Github Repository
- Create Terraform Cloud Account
- Create Organization
- Create Workspace by integrating with Github.com Git Repo we recently created
- Learn about Workspace related Queue Plan, Runs, States, Variables and Settings


## Step-02: Create new github Repository
- **URL:** github.com
- Click on **Create a new repository**
- **Repository Name:** terraform-cloud-azure-demo1
- **Description:** Terraform Cloud Azure Demo1
- **Repo Type:** Public / Private
- **Initialize this repository with:**
- **CHECK** - Add a README file
- **CHECK** - Add .gitignore 
- **Select .gitignore Template:** Terraform
- **CHECK** - Choose a license
- **Select License:** Apache 2.0 License
- Click on **Create repository**

## Step-03: Review .gitignore created for Terraform
- Review .gitignore created for Terraform projects

## Step-04: Clone Github Repository to Local Desktop
```t
# Clone Github Repo
git clone https://github.com/<YOUR_GITHUB_ID>/<YOUR_REPO>.git
git clone https://github.com/stacksimplify/terraform-cloud-azure-demo1.git
```

## Step-05: Copy files from terraform-manifests to local repo & Check-In Code
- List of files to be copied
1. c1-versions.tf
2. c2-variables.tf
3. c3-locals.tf
4. c4-resource-group.tf
5. c5-virtual-network.tf
6. c6-linux-virtual-machine.tf
7. c7-outputs.tf
8. dev.auto.tfvars
9. ssh-keys folder
10. app-scripts folder

- Verify locally before commiting to GIT Repository
```t
# Terraform Init
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Clean-Up files
rm -rf .terraform 
```
- Check-In code to Remote Repository
```t
# GIT Status
git status

# Git Local Commit
git add .
git commit -am "TF Files First Commit"

# Push to Remote Repository
git push

# Verify the same on Remote Repository
https://github.com/stacksimplify/terraform-cloud-azure-demo1.git
```

## Step-06: Sign-Up for Terraform Cloud - Free Account & Login
- **SignUp URL:** https://app.terraform.io/signup/account
- **Username:**
- **Email:**
- **Password:** 
- **Login URL:** https://app.terraform.io

## Step-07: Create Organization and Enable Free Trial
### Step-07-01: Create Organization
- **Organization Name:** hcta-azure-demo1
- **Email Address:** stacksimplify@gmail.com
- Click on **Create Organization**
### Step-07-02: Enable Free Trial for this Organization
- Go to Organization -> hcta-azure-demo1 -> Settings -> Plan & Billing
- Click on `Start your free trial This organization is eligible for a 30 day free trial of Terraform Cloud's paid features. Click here to get started`
- Select `Trial Plan`
- Click on `Start your Free Trial`

## Step-08: Create New Workspace
- Get in to newly created Organization
- Click on **New Workspace**
- **Choose your workflow:** V
  - Version Control Workflow
- **Connect to VCS**
  - **Connect to a version control provider:** github.com
  - NEW WINDOW: **Authorize Terraform Cloud:** Click on **Authorize Terraform Cloud Button**
  - NEW WINDOW: **Install Terraform Cloud**
  - **Select radio button:** Only select repositories
  - **Selected 1 Repository:** stacksimplify/terraform-cloud-azure-demo1
  - Click on **Install**
- **Choose a Repository**
  - stacksimplify/terraform-cloud-azure-demo1
- **Configure Settings**
  - **Workspace Name:** terraform-cloud-azure-demo1 (Whatever populated automically leave to defaults) 
  - **Workspace Description:** Terraform Cloud Azure Demo1
  - **Advanced Settings:** 
    - **Terraform Working Directory:** terraform-manifests
    - REST ALL LEAVE TO DEFAULTS
- Click on **Create Workspace**  
- You should see this message `Configuration uploaded successfully`

## Step-09: Terraform Cloud to Authenticate to Azure using Service Principal with a Client Secret
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

## Step-10: Configure Environment Variables in Terraform Cloud
- Go to Organization -> hcta-azure-demo1 -> Workspace ->  hcta-azure-demo1 -> Variables
- Add Environment Variables listed below
```t
ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```

## Step-11: Click on Queue Plan
- Go to Workspace -> Runs -> Queue Plan
- Review the plan generated in **Full Screen**
- Review Cost Estimation Report
- Click on **Confirm & Apply**
- **Add Comment:** First Run Approved

## Step-12: Review Terraform State
- Go to Workspace -> States
- Review the state file

## Step-13: Make changes in local Git Repo - Add New Tags
- Go to Local Desktop -> Local Repo -> c3-locals.tf -> Add new tag for all Resources
```t
# Change c3-locals.tf
Uncomment tag named `Tag1 = "Terraform-Cloud-Demo1"`

# GIT Status
git status

# Git Local Commit
git add .
git commit -am "Tag Added"

# Push to Remote Repository
git push

# Verify Terraform Cloud
Go to Workspace -> Runs 
Observation: 
1) New plan should be queued ->  Click on Current Plan and review logs in Full Screen
2) Click on **Confirm and Apply**
3) Add Comment: Approved new tag changes
4) Verify Apply Logs in Full Screen
5) Review the update state in  Workspace -> States
6) Verify if new tags got created in Azure Portal.

# Access Application
http://<PUBLIC-IP>
```


## Step-14: Make changes in local Git Repo - When Workspace in Lock State
- Go to Local Desktop -> Local Repo -> c3-locals.tf -> Add new tag for all Resources
```t
# Change c3-locals.tf
Uncomment tag named `Tag2 = "Terraform-Cloud-Demo1-Workspace-Locked"`

# GIT Status
git status

# Git Local Commit
git add .
git commit -am "Tag Added - Workspace Locked"

# Push to Remote Repository
git push

# Verify Terraform Cloud
Go to Workspace -> Runs 
Message: Workspace locked by user stacksimplify. It must be unlocked before Terraform can execute.

# Unlock Workspace 
Unlock the workspace.

Observation: 
1) New plan should be queued ->  Click on Current Plan and review logs in Full Screen
2) Click on **Confirm and Apply**
3) Add Comment: Approved new tag changes
4) Verify Apply Logs in Full Screen
5) Review the update state in  Workspace -> States
6) Verify if new tags got created in Azure Portal.
```

## Step-15: Review Workpace Settings
- Goto -> Workspace -> Settings
1. General Settings
2. Locking
3. Notifications
4. Run Triggers
5. SSH Key
6. Version Control

## Step-15: Destruction and Deletion
- Goto -> Workspace -> Settings -> Destruction and Deletion
- click on **Queue Destroy Plan** to delete the resources on cloud 
- Goto -> Workspace -> Runs -> Click on **Confirm & Apply**
- **Add Comment:** Approved for Deletion

## Step-16: Comment c3-locals.tf
- Comment both tags (Tag1, Tag2) in c3-locals.tf for student seamless demo 
```t
  common_tags = {
    Service = local.service_name
    Owner   = local.owner
    #Tag1 = "Terraform-Cloud-Demo1"
    #Tag2 = "Terraform-Cloud-Demo1-Workspace-Locked"
  }
```
