---
title: Terraform Output Values with Splat Expression
description: Learn about Terraform Output Values with Splat Expression
---

## Step-01: Introduction
- Understand how to define outputs when we are using the Meta-Argument `count`
- What is [Splat Expression](https://www.terraform.io/docs/language/expressions/splat.html) ?
- Why do we ned to use in `outputs` when we use `count` ?

- **Splat Expression:** A `splat expression` provides a more concise way to express a common operation that could otherwise be performed with a `for` expression.
- The special [*] symbol iterates over all of the elements of the list given to its left and accesses from each one the attribute name given on its right. 
```t
# With for expression
[for o in var.list : o.id]

# With Splat Expression [*]
var.list[*].id
```

## Step-02: c4-virtual-networ.tf
- Add Resource Meta-Argument `count` to `azurerm_virtual_network` resource
```t
# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  count = 4
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}-${count.index}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}
```

## Step-03: Execute Terraform Commands
```t
# Initialize Terraform
terraform init

# Validate Terraform configuration files
terraform validate

# Observation
1. It should fail

# Sample Output
Kalyans-MacBook-Pro:terraform-manifests kdaida$ terraform validate
╷
│ Error: Missing resource instance key
│ 
│   on c5-outputs.tf line 16, in output "virtual_network_name":
│   16:   value = azurerm_virtual_network.myvnet.name 
│ 
│ Because azurerm_virtual_network.myvnet has "count" set, its attributes must be
│ accessed on specific instances.
│ 
│ For example, to correlate with indices of a referring resource, use:
│     azurerm_virtual_network.myvnet[count.index]
Kalyans-MacBook-Pro:terraform-manifests kdaida$ 

```

## Step-04: c5-outputs.tf
- Update Splat Expression for output named `virtual_network_name`
```t
# 2. Output Values - Virtual Network
output "virtual_network_name" {
  description = "Virutal Network Name"
  value = azurerm_virtual_network.myvnet[*].name 
}
```

## Step-06: Execute Terraform Commands
```t
# Validate Terraform configuration files
terraform validate
Observation: Should passs

# Format Terraform configuration files
terraform fmt

# Review the terraform plan
terraform plan 
Observation: should pass

# Sample Output
Plan: 5 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + resource_group_id    = (known after apply)
  + resource_group_name  = "it-dev-rg"
  + virtual_network_name = [
      + "it-dev-vnet-0",
      + "it-dev-vnet-1",
      + "it-dev-vnet-2",
      + "it-dev-vnet-3",
    ]



# Create Resources (Optional)
terraform apply -auto-approve

# Observation
1. Should get all the virtual network names as a list
```

## Step-07: Destroy Resources
```t
# Destroy Resources
terraform destroy -auto-approve

# Clean-Up
rm -rf .terraform*
rm -rf terraform.tfstate*
```


## References
- [Terraform Output Values](https://www.terraform.io/docs/language/values/outputs.html)