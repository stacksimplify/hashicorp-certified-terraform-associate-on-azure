---
title: Terraform Meta-Argument lifecycle prevent_destroy
description: Learn Terraform Resource Meta-Argument lifecycle prevent_destroy
---

## Step-01: Introduction
- lifecyle Meta-Argument block contains 3 arguments
1. create_before_destroy
2. prevent_destroy
3. ignore_changes
- We are going to practically understand and implement `prevent_destroy`  

## Step-02: Review Terraform Manifests
- c1-versions.tf
- c2-resource-group.tf
- c3-virtual-network.tf

## Step-03: lifecycle - prevent_destroy
- This meta-argument `prevent_destroy`, when set to true, will cause Terraform to reject with an error any plan that would destroy the infrastructure object associated with the resource, as long as the argument remains present in the configuration.
- This can be used as a measure of safety against the accidental replacement of objects that may be costly to reproduce, such as database instances
- However, it will make certain configuration changes impossible to apply, and will prevent the use of the `terraform destroy` command once such objects are created, and so this option should be used `sparingly`.
- Since this argument must be present in configuration for the protection to apply, note that this setting does not prevent the remote object from being destroyed if the resource block were removed from configuration entirely: in that case, the `prevent_destroy` setting is removed along with it, and so Terraform will allow the destroy operation to succeed.
```t
# Lifecycle Block
  lifecycle {
    prevent_destroy = true # Default is false
  }
```
## Step-04: Execute Terraform Commands
```t
# Switch to Working Directory
cd terraform-manifests

# Initialize Terraform
terraform init

# Validate Terraform Configuration Files
terraform validate

# Format Terraform Configuration Files
terraform fmt

# Generate Terraform Plan
terraform plan

# Create Resources
terraform apply -auto-approve

# Destroy Resource
terraform destroy 
```
- **Sample Output when we run destroy**
```log
Kalyans-MacBook-Pro:v7-terraform-manifests kdaida$ terraform apply -auto-approve
random_string.myrandom: Refreshing state... [id=xpeska]
azurerm_resource_group.myrg: Refreshing state... [id=/subscriptions/82808767-144c-4c66-a320-b30791668b0a/resourceGroups/myrg-1]
azurerm_virtual_network.myvnet: Refreshing state... [id=/subscriptions/82808767-144c-4c66-a320-b30791668b0a/resourceGroups/myrg-1/providers/Microsoft.Network/virtualNetworks/myvnet-1]
╷
│ Error: Instance cannot be destroyed
│ 
│   on c3-virtual-network.tf line 2:
│    2: resource "azurerm_virtual_network" "myvnet" {
│ 
│ Resource azurerm_virtual_network.myvnet has lifecycle.prevent_destroy set, but the
│ plan calls for this resource to be destroyed. To avoid this error and continue
│ with the plan, either disable lifecycle.prevent_destroy or reduce the scope of the
│ plan using the -target flag.
╵
Kalyans-MacBook-Pro:v7-terraform-manifests kdaida$ 
```

## Step-05: Comment Lifecycle block to destroy Resources
```t
# Remove/Comment Lifecycle block
- Remove or Comment lifecycle block and clean-up

# Destroy Resource after removing lifecycle block
terraform destroy

# Clean-Up
rm -rf .terraform*
rm -rf terraform.tfstate*
```


## References
- [Resource Meat-Argument: Lifecycle](https://www.terraform.io/docs/language/meta-arguments/lifecycle.html)