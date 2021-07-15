---
title: Terraform Output Values with for_each and for loop
description: Learn about Terraform Output Values for_each and for loop
---
## Step-01: Introduction
- We are going to define output values of a resource when we use the Resource Meta-Argument `for_each`
- Splat Expression is not going to work for this.
- Resources that use the for_each argument will appear in expressions as a map of objects, so you can't use [splat expressions](https://www.terraform.io/docs/language/expressions/splat.html#splat-expressions-with-maps) with those resources. 
- We need to use regular `for loop` in `output values` to get the values of a specific attribute or argument from a Resource in Outputs. 
- [Terraform For expression](https://www.terraform.io/docs/language/expressions/for.html)
- [Terraform Keys Function](https://www.terraform.io/docs/language/functions/keys.html)
- [Terraform Values Function](https://www.terraform.io/docs/language/functions/values.html)

## Step-02: c2-variables.tf
- Update `environment` variable to Variable Type `set`
```t
# 2. Environment Name
variable "environment" {
  description = "Environment Name"
  type = set(string)
  default = ["dev1", "qa1", "staging1", "prod1" ]
}
```

## Step-03: terraform.tfvars
- Update the values for variable `environment`
```t
business_unit = "it"
environment =  ["dev2", "qa2", "staging2", "prod2" ]
resoure_group_name = "rg"
virtual_network_name = "vnet"
```

## Step-04: c4-virtual-network.tf
- Convert the existing vnet resource with `for_each`
```t
# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  for_each = var.environment
  name                = "${var.business_unit}-${each.key}-${var.virtual_network_name}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}
```

## Step-05: c5-outputs.tf
- Test using `splat expression` in output values (same as we used for count)
```t
# 2. Output Values - Virtual Network
output "virtual_network_name" {
  description = "Virutal Network Name"
  value = azurerm_virtual_network.myvnet[*].name 
  #sensitive = true
}

# Initialize Terraform
terraform init

# Validate Terraform configuration files
terraform validate

# Review the terraform plan
terraform plan 
Observation: Should fail

# Sample Ouput
Kalyans-MacBook-Pro:terraform-manifests kdaida$ terraform plan
╷
│ Error: Unsupported attribute
│ 
│   on c5-outputs.tf line 18, in output "virtual_network_name":
│   18:   value = azurerm_virtual_network.myvnet[*].name 
│ 
│ This object does not have an attribute named "name".
╵
Kalyans-MacBook-Pro:terraform-manifests kdaida$ 

```

## Step-06: c5-outputs.tf
- Implement `for loop` 
1. For Loop One Input and List Output with VNET Name 
2. For Loop Two Inputs, List Output which is Iterator i (var.environment)
3. For Loop One Input and Map Output with VNET ID and VNET Name
4. For Loop Two Inputs and Map Output with Iterator env and VNET Name
5. Terraform keys() function
6. Terraform values() function
```t

# Output - For Loop One Input and List Output with VNET Name 
output "virtual_network_name_list_one_input" {
  description = "Virutal Network Name"
  value = [ for vnet in azurerm_virtual_network.myvnet: vnet.name]
}

# Output - For Loop Two Inputs, List Output which is Iterator i (var.environment)
output "virtual_network_name_list_two_inputs" {
  description = "Virutal Network Name"
  #value = [ for i, vnet in azurerm_virtual_network.myvnet: i]
  value = [ for env, vnet in azurerm_virtual_network.myvnet: env]
}

# Output - For Loop One Input and Map Output with VNET ID and VNET Name
output "virtual_network_name_map_one_input" {
  description = "Virutal Network Name"
  value = {for vnet in azurerm_virtual_network.myvnet: vnet.id => vnet.name}
}

# Output - For Loop Two Inputs and Map Output with Iterator env and VNET Name
output "virtual_network_name_map_two_inputs" {
  description = "Virutal Network Name"
  value = {for env, vnet in azurerm_virtual_network.myvnet: env => vnet.name}
}

# Terraform keys() function: keys takes a map and returns a list containing the keys from that map.
output "virtual_network_name_keys_function" {
  description = "Virutal Network Name - keys() Function Explore"
  value = keys({for vnet in azurerm_virtual_network.myvnet: vnet.id => vnet.name})
}

# Terraform values() function: values takes a map and returns a list containing the values of the elements in that map.
output "virtual_network_name_values_function" {
  description = "Virutal Network Name - values() Function Explore"
  value = values({for vnet in azurerm_virtual_network.myvnet: vnet.id => vnet.name})
}


```

## Step-07: Execute Terraform Commands
```t
# Initialize Terraform
terraform init

# Validate Terraform configuration files
terraform validate

# Review the terraform plan
terraform plan 
Observation:
1. Command should successfully generate the terraform plan

# Sample Output
Changes to Outputs:
  + resource_group_id    = (known after apply)
  + resource_group_name  = "myrg1-demo"
  + virtual_network_name = [
      + "it-dev2-vnet",
      + "it-prod2-vnet",
      + "it-qa2-vnet",
      + "it-staging2-vnet",
    ]

# Create Resources (Optional)
terraform apply -auto-approve
```

## Step-08: Destroy Resources
```t
# Destroy Resources
terraform destroy -auto-approve

# Clean-Up
rm -rf .terraform*
rm -rf terraform.tfstate*
```


## References
- [Terraform Output Values](https://www.terraform.io/docs/language/values/outputs.html)