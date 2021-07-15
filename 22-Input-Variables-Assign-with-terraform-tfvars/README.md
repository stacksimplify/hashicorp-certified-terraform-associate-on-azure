---
title: Terraform Input Variables using terraform.tfvars
description: Learn Terraform Input Variables using terraform.tfvars
---
## Step-01: Introduction
- Provide Input Variables using `terraform.tfvars` files

## Step-02: Assign Input Variables from terraform.tfvars
- Create a file named `terraform.tfvars` and define variables
- If the file name is `terraform.tfvars`, terraform will auto-load the variables present in this file by overriding the `default` values in `c2-variables.tf`
```t
business_unit = "it"
environment = "stg"
resoure_group_name = "rg-tfvars"
resoure_group_location = "eastus2"
virtual_network_name = "vnet-tfvars"
subnet_name = "subnet-tfvars"
```

## Step-03: Execute Terraform Commands
```t
# Initialize Terraform
terraform init

# Validate Terraform configuration files
terraform validate

# Format Terraform configuration files
terraform fmt

# Review the terraform plan
terraform plan

# Create Resources
terraform apply

# Verify Resources
1. Resource Group Name
2. Resource Group Location
3. Virtual Network Name
4. Virtual Network Subnet Name 
5. Compare with names present in  c2-variables.tf to reconfirm it has overrided it and took from terraform.tfvars
```

## Step-04: Clean-Up Files
```t
# Destroy Resources
terraform destroy -auto-approve

# Delete Files
rm -rf .terraform*
rm -rf terraform.tfstate*
```


## References
- [Terraform Input Variables](https://www.terraform.io/docs/language/values/variables.html)



