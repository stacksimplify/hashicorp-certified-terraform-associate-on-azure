---
title: Terraform Remote State Datasource
description: Learn about Terraform Remote State Datasource
---

## Step-01: Introduction
- Understand about [Terraform Remote State Datasource](https://www.terraform.io/docs/language/state/remote-state-data.html)
- Terraform Remote State Storage Demo with two projects

## Step-02: Project-1: Create / Review Terraform Configs
1. c1-versions.tf
2. c2-variables.tf
3. c3-locals.tf
4. c4-resource-group.tf
5. c5-virtual-network.tf
6. c6-outputs.tf
7. terraform.tfvars

## Step-03: Porject-1: Execute Terraform Commands
```t
# Change Directory 
cd project-1-network

# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-approve

# Observation
1. Verify Resource Group 
2. Verify Virtual Network
3. Verify Virtual Network Subnet 
4. Verify Public IP
5. Verify Network Interface
6. Verify Storage Account - TFState file
```
## Step-04: Project-2: Create / Review Terraform Configs
1. c0-terraform-remote-state-datasource.tf
2. c1-versions.tf
3. c2-variables.tf
4. c3-locals.tf
5. c4-linux-virtual-machine.tf
6. c5-outputs.tf
7. terraform.tfvars

## Step-05: Project-2: c0-terraform-remote-state-datasource.tf
- Understand in depth about Terraform Remote State Datasource
```t
# Terraform Remote State Datasource
data "terraform_remote_state" "project1" {
  backend = "azurerm"
  config = {
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformstate201"
    container_name        = "tfstatefiles"
    key                   = "network-terraform.tfstate"
  }
}

/*
1. Resource Group Name
data.terraform_remote_state.project1.outputs.resource_group_name
2. Resource Group Location
data.terraform_remote_state.project1.outputs.resource_group_location
3. Network Interface ID
data.terraform_remote_state.project1.outputs.network_interface_id
*/
```

## Step-06: Project-2: c4-linux-virtual-machine.tf
- Understand the core changes in `Virtual Machine Resource` with Terraform Remote State Datasource
```t
# Before (Using Single Project)
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  network_interface_ids = [azurerm_network_interface.myvmnic.id]
  
# After (Using Two Projects and with Terraform Remote State Datasource)  
  # Getting Data using Terraform Remote State Datasource from Project-1
  resource_group_name = data.terraform_remote_state.project1.outputs.resource_group_name
  location = data.terraform_remote_state.project1.outputs.resource_group_location
  network_interface_ids = [data.terraform_remote_state.project1.outputs.network_interface_id]
```


## Step-07: Project-2: Execute Terraform Commands
```t
# Change Directory 
cd project-2-app1

# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-approve

# Observation
1. Verify Resource Group 
2. Verify Virtual Network
3. Verify Virtual Network Subnet 
4. Verify Public IP
5. Verify Network Interface
6. Verify Virtual Machine Resource (Location it created, Network Interface it used)
7. Verify Storage Account - TFState file
```

## Step-08: Project-2: Clean-Up
```t
# Change Directory 
cd project-2-app1

# Destroy Resources
terraform destroy -auto-approve

# Delete Files
rm -rf .terraform*
```

## Step-09: Project-1: Clean-Up
```t
# Change Directory 
cd project-1-network

# Destroy Resources
terraform destroy -auto-approve

# Delete Files
rm -rf .terraform*
```
