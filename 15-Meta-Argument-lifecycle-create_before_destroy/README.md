---
title: Terraform Meta-Argument lifecycle create_before_destroy
description: Learn Terraform Resource Meta-Argument lifecycle create_before_destroy
---
## Step-01: Introduction
- lifecyle Meta-Argument block contains 3 arguments
1. create_before_destroy
2. prevent_destroy
3. ignore_changes
- We are going to practically understand and implement `create_before_destroy`  

## Step-02: Review Terraform Manifests
- c1-versions.tf
- c2-resource-group.tf
- c3-virtual-network.tf

## Step-03: lifecyle - create_before_destroy
- Default Behavior of a Resource: Destroy Resource & re-create Resource
- With Lifecycle Block we can change that using `create_before_destroy=true`
  - First new resource will get created
  - Second old resource will get destroyed
- **Add Lifecycle Block inside Resource Block to alter behavior**  
```t
# Lifecycle Block inside a Resource
  lifecycle {
    create_before_destroy = true
  }
```  
## Step-04: Observe without Lifecycle Block
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

# Modify Resource Configuration
Change Virtual Network Name from  myvnet-1 to myvnet-2

# Apply Changes
terraform apply -auto-approve
Observation: 
1) First myvnet-1 resource will be destroyed
2) Second myvnet-2 resource will get
```
## Step-05: With Lifecycle Block
- Add Lifecycle block in the resource (Uncomment lifecycle block)
```t
# Generate Terraform Plan
terraform plan

# Apply Changes
terraform apply -auto-approve

# Modify Resource Configuration
Change Virtual Network Name from myvnet-2 to myvnet-1

# Apply Changes
terraform apply -auto-approve
Observation: 
1) First myvnet-1 resource will get created
2) Second myvnet-2 resource will get deleted
```
## Step-06: Clean-Up Resources
```t
# Destroy Resources
terraform destroy -auto-approve

# Clean-Up 
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## References
- [Resource Meat-Argument: Lifecycle](https://www.terraform.io/docs/language/meta-arguments/lifecycle.html)