---
title: Terraform Cloud and Sentinel Policies
description: Learn about Terraform Cloud and Sentinel Policies
---

## Step-01: Introduction
- We are going to learn the following in this section
- Verify if Trial plan for 30 days on hcta-azure-demo1 organization which will enable **Team & Governance** features of Terraform Cloud
- Implement `CLI-Driven workflow using Terraform Cloud` for multiple Azure Resources
1. azurerm_resource_group
2. azurerm_linux_virtual_machine
3. azurerm_virtual_network
4. azurerm_public_ip
5. azurerm_network_interface
- Understand about following  5 sentinel policies
1. allowed-providers.sentinel
2. enforce-mandatory-tags.sentinel
3. limit-proposed-monthly-cost.sentinel
4. restrict-vm-publisher.sentinel
5. restrict-vm-size.sentinel
- Understand about defining `sentinel.hcl`
- Create Github repository for Sentinel Policies to use them as Policy Sets in Terraform Cloud
- Create Policy Sets in Terraform Cloud and Apply to demo workspace
- Test if sentinel policies applied and worked successfully.  
- Understand about [Terraform Sentinel policy Enforcement Levels](https://www.terraform.io/docs/cloud/sentinel/enforce.html)
1. advisory
2. soft-mandatory
3. hard-mandatory

## Step-02: Review Terraform manifests
1. c1-versions.tf
2. c2-variables.tf
3. c3-locals.tf
4. c4-resource-group.tf
5. c5-virtual-network.tf
6. c6-linux-virtual-machine.tf
7. c7-outputs.tf
8. dev.auto.tfvars

## Step-03: Review the Git-Repo-Files-Sentinel
- First Review the Terraform Governance guides - Third Generation (As on today)
- [Terraform Governance Guides](https://github.com/hashicorp/terraform-guides/tree/master/governance)
1. common-functions folder
2. azure-functions folder
3. terraform-generic-sentinel-policies

## Step-04: Review 5 Sentinel Policies and sentinel.hcl
1. allowed-providers.sentinel
2. enforce-mandatory-tags.sentinel
3. limit-proposed-monthly-cost.sentinel
4. restrict-vm-publisher.sentinel
5. restrict-vm-size.sentinel
6. sentinel.hcl


## Step-03: Create CLI-Driven Workspace on Terraform Cloud
### Step-03-01: Verify Trial plan in hcta-azure-demo1 organization
- Login to Terraform Cloud
- Goto -> Organizations (hcta-azure-demo1) -> Settings -> Plan & Billing
- Verify `Current Plan`
```t
Free Trial
You are currently trialing Terraform Cloud's premium features, including improved team management , Sentinel policies , and cost estimation .
Your plan will change to Free on July 15th 2021 . Click here to select your next plan.
```

### Step-03-02: Create CLI-Driven Workspace in organization hcta-azure-demo1
- Login to [Terraform Cloud](https://app.terraform.io/)
- Select Organization -> hcta-azure-demo1
- Click on **New Workspace**
- **Choose your workflow:** CLI-Driven Workflow
- **Workspace Name:** sentinel-azure-demo1
- Click on **Create Workspace**

### Step-03-03: Update c1-versions.tf with Terraform Backend in Terraform Block
```t
  # Terraform Backend pointed to TF Cloud
  backend "remote" {
    organization = "hcta-azure-demo1-internal"

    workspaces {
      name = "sentinel-azure-demo1"
    }
  }
```


## Step-04: Terraform Cloud to Authenticate to Azure using Service Principal with a Client Secret
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

## Step-05: Configure Environment Variables in Terraform Cloud
- Go to Organization -> hcta-azure-demo1 -> Workspace ->  cli-driven-azure-demo -> Variables
- Add Environment Variables listed below
```t
ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```


## Step-06: Create Github Repository for Sentinel Policies (Policy Sets)
### Step-06-01: Create new github Repository
- **URL:** github.com
- Click on **Create a new repository**
- **Repository Name:** terraform-sentinel-policies-azure
- **Description:** Terraform Cloud and Sentinel Policies Demo on Azure
- **Repo Type:** Public / Private
- **Initialize this repository with:**
- **CHECK** - Add a README file
- **CHECK** - Add .gitignore 
- **Select .gitignore Template:** Terraform
- **CHECK** - Choose a license  (Optional)
- **Select License:** Apache 2.0 License
- Click on **Create repository**

## Step-06-02: Clone Github Repository to Local Desktop
```t
# Clone Github Repo
git clone https://github.com/<YOUR_GITHUB_ID>/<YOUR_REPO>.git
git clone https://github.com/stacksimplify/terraform-sentinel-policies.git
```

## Step-06-03: Copy files from terraform-sentinel-policies folder to local repo & Check-In Code

- **Source Location:** Git-Repo-Files-Sentinel
- **Destination Location:** Copy all folders and files from `Git-Repo-Files-Sentinel` newly cloned github repository folder in your local desktop `terraform-sentinel-policies-azure`
- **Check-In code to Remote Repository**
```t
# GIT Status
git status

# Git Local Commit
git add .
git commit -am "Sentinel Policies First Commit"

# Push to Remote Repository
git push

# Verify the same on Remote Repository
https://github.com/stacksimplify/terraform-sentinel-policies-azure.git
```

## Step-07: Create Policy Sets in Terraform Cloud
- Go to Terraform Cloud -> Organization (hcta-azure-demo1) -> Settings -> Policy Sets
- Click on **Connect a new Policy Set**
- Use existing VCS connection from previous section **github-terraform-modules** which we created using OAuth App concept
- **Choose Repository:** terraform-sentinel-policies-azure.git
- **Description:** Demo Sentinel Policies
- **Additional Options** - **Policies Path:** terraform-generic-sentinel-policies
- **Scope of Policies:** Policies enforced on selected workspaces
- **Workspaces:** sentinel-azure-demo1
- Click on **Connect Policy Set**


## Step-08: Execute Terraform Commands
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


# Terrafrom Initialize
terraform init

# Terraform Apply
terraform apply 

# Observation
1) Primarily verify Sentinel Policies in Terraform Cloud
2) Verify Sentinel Enforcement Mode `advisory` for `limit-proposed-monthly-cost`
3) Everything should pass and we should go to next level to confirm changes
```

## Step-09: Verify Sentinel Enforcement Mode soft-mandatory
```t
# Change "limit-proposed-monthly-cost" sentinel policy to soft-mandatory in sentinel.hcl
policy "limit-proposed-monthly-cost" {
    source = "./limit-proposed-monthly-cost.sentinel"
    enforcement_level = "soft-mandatory"
}

# GIT Status
git status

# Git Local Commit
git add .
git commit -am "soft-mandatory Commit"

# Push to Remote Repository
git push



# Terraform Apply
terraform apply 

# Observation
1) Primarily verify Sentinel Policies in Terraform Cloud
2) "limit-proposed-monthly-cost.sentinel" policy check should fail and tell us we have option to "override" and continue
```

## Step-10: Verify Sentinel Enforcement Mode hard-mandatory
```t
# Change "limit-proposed-monthly-cost" sentinel policy to hard-mandatory in sentinel.hcl
policy "limit-proposed-monthly-cost" {
    source = "./limit-proposed-monthly-cost.sentinel"
    enforcement_level = "hard-mandatory"
}

# GIT Status
git status

# Git Local Commit
git add .
git commit -am "hard-mandatory Commit"

# Push to Remote Repository
git push

# Terraform Apply
terraform apply 

# Observation
1) Primarily verify Sentinel Policies in Terraform Cloud
2) "limit-proposed-monthly-cost.sentinel" policy check should fail and Terraform Execution should stop there.
3) We don't have an option to continue or override and go to next step. 
```


## Step-11: Clean-Up & Destroy
```t
# Terraform Destroy
terraform destroy -auto-approve

# Clean-Up files
rm -rf .terraform*


# Rollback in Repo
policy "limit-proposed-monthly-cost" {
    source = "./limit-proposed-monthly-cost.sentinel"
    enforcement_level = "advisory"
}

# GIT Status
git status

# Git Local Commit
git add .
git commit -am "hard-mandatory Commit"

# Push to Remote Repository
git push
```

## Step-12: Roll back changes to have seamless demo to Students
```t
# Change "limit-proposed-monthly-cost" sentinel policy to advisory in sentinel.hcl
policy "limit-proposed-monthly-cost" {
    source = "./limit-proposed-monthly-cost.sentinel"
    enforcement_level = "advisory"
}
```

## References 
- [Terraform & Sentinel](https://www.terraform.io/docs/cloud/sentinel/index.html)
- [Example Sentinel Policies](https://www.terraform.io/docs/cloud/sentinel/examples.html)
- [Sentinel Foundational Policies](https://github.com/hashicorp/terraform-foundational-policies-library)
- [Sentinel Enforcement Levels](https://docs.hashicorp.com/sentinel/concepts/enforcement-levels)
- [Terraform Governance](https://github.com/hashicorp/terraform-guides/tree/master/governance/third-generation)











)