---
title: Terraform Settings, Providers and Resource Blocks 
description: Learn Key blocks of Terraform like Settings, Providers and Resource Blocks
---

## Step-01: Introduction
### Terraform Block
- Understand about Terraform Block and its importance
- Understand how to handle version constraints for Terraform Version and Provider Version in Terraform Block
### Provider Block
- What are Terraform Providers?
- What Providers Do?
- Where do providers reside (Terraform Registry)?
- How to use Providers?
- What are Provider Badges?

### Step-02: Understand about Terraform Settings Block
- [Terraform Settings Block](https://www.terraform.io/docs/language/settings/index.html)
- Required Terraform Version
- Provider Requirements
- Terraform backends
- Experimental Language Features
- Passing Metadata to Providers
- Reference `sample-terraform-settings.tf` for additional understanding. 

## Step-03: Create a simple terraform block and play with required_version
- `required_version` focuses on underlying Terraform CLI installed on your desktop
- If the running version of Terraform on your local desktop doesn't match the constraints specified in your terraform block, Terraform will produce an error and exit without taking any further actions.
- By changing the versions try `terraform init` and observe whats happening
```t
# Play with Terraform CLI Version (We installed 1.0.0 version)
  required_version = "~> 0.14.3" - Will fail
  required_version = "~> 0.14"   - Will fail  
  required_version = "= 0.14.4"  - Will fail
  required_version = ">= 0.13"   - will pass
  required_version = "= 1.0.0"   - will pass
  required_version = "1.0.0"     - will pass 
  required_version = ">= 1.0.0"   - will pass   
 
# Terraform Block
terraform {
  required_version = ">= 1.0.0"
}

# To view my Terraform CLI Version installed on my desktop
terraform version

# Initialize Terraform
terraform init
```


## Step-04: Terraform Providers
- What are [Terraform Providers](https://www.terraform.io/docs/language/providers/configuration.html)?
- What Providers Do?
- Where do providers reside (Terraform Registry)?


## Step-05: Provider Requirements
- Define required providers in Terraform Block
- Understand about three things about defining `required_providers` in terraform block
  - local names
  - source
  - version
```t
# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0"
    }
  }
}
```


## Step-06: Provider Block  
- Create a Provider Block for Azure Resource Management `azurerm`
```t
# Provider Block
provider "azurerm" {
features {}
}
```
- Discuss about [Authentication Types](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure) 
- Authenticating to Azure using the Azure CLI
- Authenticating to Azure using Managed Service Identity
- Authenticating to Azure using a Service Principal and a Client Certificate
- Authenticating to Azure using a Service Principal and a Client Secret  
- Finally, understand about [Features Block](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#features) in Provider Block 
```t
# Initialize Terraform
terraform init

# Validate Terraform Configuration files
terraform validate

# Execute Terraform Plan
terraform plan
```  

## Step-07: Add Provider and play with Provider version
- `required_providers` block specifies all of the providers required by the current module, mapping each local provider name to a source address and a version constraint.

```t
# Play with Provider Version
      version = "~> 2.0"            
      version = ">= 2.0.0, < 2.60.0"
      version = ">= 2.0.0, <= 2.64.0"

# Terraform Init with upgrade option to change provider version
terraform init -upgrade
```

## Step-08: Create a simple Resource Block - c2-resource-group.tf
```t
# Resource Block
# Create a resource group
resource "azurerm_resource_group" "myrg" {
  name = "myrg-1"
  location = "East US"
}
```


## Step-09: Execute Terraform commands 
```t
# Initialize Terraform
terraform init

# Validate Terraform Configuration files
terraform validate

# Execute Terraform Plan
terraform plan

# Create Resources using Terraform Apply
terraform apply -auto-approve
```  

## Step-10: Clean-Up 
```t
# Destroy Terraform Resources
terraform destroy -auto-approve

# Delete Terraform Files
rm -rf .terraform*
rm -rf terraform.tfstate*
```


## References
- [Terraform Providers](https://www.terraform.io/docs/configuration/providers.html)
- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Resource Group Terraform Resource](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
- [Terraform Version Constraints](https://www.terraform.io/docs/configuration/version-constraints.html)
- [Terraform Versions - Best Practices](https://www.terraform.io/docs/configuration/version-constraints.html#best-practices)

