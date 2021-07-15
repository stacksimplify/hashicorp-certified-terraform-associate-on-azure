---
title: Terraform Workspaces with Local Backend
description: Learn Terraform Workspaces with Local Backend
---

## Step-01: Introduction
- We are going to use Terraform Local Backend 
- We are going to create 2 workspaces (default, dev) in addition to default workspace
- Update our terraform manifests to support `terraform workspace` 
- Master the below listed `terraform workspace` commands
1. terraform workspace show
2. terraform workspace list
3. terraform workspace new
4. terraform workspace select
5. terraform workspace delete


## Step-02: Review Terraform Configs and make changes
- Copy `terraform-manifests` from `38-Terraform-Remote-State-Storage-and-Locking` and make following changes

## Step-03: c1-versions.tf
- Remove Backend block from Terraform Settings block if any present
```t
# Terraform State Storage to Azure Storage Container
  backend "azurerm" {
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformstate201"
    container_name        = "tfstatefiles"
    key                   = "terraform.tfstate"
  } 
```

## Step-04: c3-locals.tf
- What is **${terraform.workspace}**? - It will get the workspace name 
- **Popular Usage-1:** Using the workspace name as part of naming or tagging behavior
- **Popular Usage-2:** Referencing the current workspace is useful for changing behavior based on the workspace. For example, for non-default workspaces, it may be useful to spin up smaller cluster sizes.

- Replace `${var.environment}` with `${terraform.workspace}` for all resource names
```t
  rg_name = "${var.business_unit}-${terraform.workspace}-${var.resoure_group_name}"
  vnet_name = "${var.business_unit}-${terraform.workspace}-${var.virtual_network_name}"
  snet_name = "${var.business_unit}-${terraform.workspace}-${var.subnet_name}"
  pip_name = "${var.business_unit}-${terraform.workspace}-${var.publicip_name}"
  nic_name = "${var.business_unit}-${terraform.workspace}-${var.network_interface_name}"
  vm_name = "${var.business_unit}-${terraform.workspace}-${var.virtual_machine_name}"
```

## Step-05: c5-virtual-network.tf
- Update Public IP `domain_name_label` with `${terraform.workspace}`
```t
# Create Public IP Address
resource "azurerm_public_ip" "mypublicip" {
  name                = local.pip_name
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label = "app1-${terraform.workspace}-${random_string.myrandom.id}"
  tags = local.common_tags
}
```

## Step-06: Create resources in default workspaces
- Default Workspace: Every initialized working directory has at least one workspace. 
- If you haven't created other workspaces, it is a workspace named **default**
- For a given working directory, only one workspace can be selected at a time.
- Most Terraform commands (including provisioning and state manipulation commands) only interact with the currently selected workspace.
```t
# Terraform Init
terraform init 

# List Workspaces
terraform workspace list

# Output Current Workspace using show
terraform workspace show

# Terraform Plan
terraform plan
Observation: 
1. The names of Resources should have "default" in them in place of environment
2. Resource Group Name: it-default-rg
3. Virtual Network: it-default-vnet
4. Subnet Name: it-default-subnet
5. Public IP Name: it-default-publicip
6. Network Interface Name: it-default-nic
7. Virtual Machine Name: it-default-vm

# Terraform Apply
terraform apply -auto-approve

# Verify
Verify the same in Azure Management console
Observation: 
1. The names of Resources should have "default" in them in place of environment
2. Resource Group Name: it-default-rg
3. Virtual Network: it-default-vnet
4. Subnet Name: it-default-subnet
5. Public IP Name: it-default-publicip
6. Network Interface Name: it-default-nic
7. Virtual Machine Name: it-default-vm

# Access Application
http://<public-ip-dns-name>
```

## Step-07: Create New Workspace and Provision Infra 
```t
# Create New Workspace
terraform workspace new dev

# Verify the folder
cd terraform.tfstate.d 
cd dev
ls
cd ../../

# Terraform Plan
terraform plan
Observation:  
1. The names of Resources should have "dev" in them in place of environment
2. Resource Group Name: it-dev-rg
3. Virtual Network: it-dev-vnet
4. Subnet Name: it-dev-subnet
5. Public IP Name: it-dev-publicip
6. Network Interface Name: it-dev-nic
7. Virtual Machine Name: it-dev-vm

# Terraform Apply
terraform apply -auto-approve

# Verify Dev Workspace statefile
cd terraform.tfstate.d/dev
ls
cd ../../
Observation: You should fine "terraform.tfstate" in "current-working-directory/terraform.tfstate.d/dev" folder

# Verify Resources in Azure mgmt console
Observation:
1. The names of Resources should have "dev" in them in place of environment
2. Resource Group Name: it-dev-rg
3. Virtual Network: it-dev-vnet
4. Subnet Name: it-dev-subnet
5. Public IP Name: it-dev-publicip
6. Network Interface Name: it-dev-nic
7. Virtual Machine Name: it-dev-vm

# Access Application
http://<public-ip-dns-name>
```

## Step-08: Switch workspace and destroy resources
- Switch workspace from `dev to default` and destroy resources in default workspace
```t
# Show current workspace
terraform workspace show

# List Worksapces
terraform workspace list

# Workspace select
terraform workspace select default

# Delete Resources from default workspace
terraform destroy -auto-approve

# Verify
1) Verify in Azure Mgmt Console (all the resources should be deleted)
```

## Step-09: Delete dev workspace
- We cannot delete "default" workspace
- We can delete workspaces which we created (dev, qa etc)
```t
# Delete Dev Workspace
terraform workspace delete dev
Observation: Workspace "dev" is not empty.
Deleting "dev" can result in dangling resources: resources that
exist but are no longer manageable by Terraform. Please destroy
these resources first.  If you want to delete this workspace
anyway and risk dangling resources, use the '-force' flag.

# Switch to Dev Workspace
terraform workspace select dev

# Destroy Resources
terraform destroy -auto-approve

# Delete Dev Workspace
terraform workspace delete dev
Observation:
Workspace "dev" is your active workspace.
You cannot delete the currently active workspace. Please switch
to another workspace and try again.

# Switch Workspace to default
terraform workspace select default

# Delete Dev Workspace
terraform workspace delete dev
Observation: Successfully delete workspace dev

# Verify 
In Azure mgmt console, all Resources should be deleted
```

## Step-10: Clean-Up Local folder
```t
# Clean-Up local folder
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## References
- [Terraform Workspaces](https://www.terraform.io/docs/language/state/workspaces.html)
- [Managing Workspaces](https://www.terraform.io/docs/cli/workspaces/index.html)