---
title: Terraform Input Variables with Validation Rules
description: Learn Terraform Input Variables with Validation Rules
---
## Step-01: Introduction
- Learn some Terraform Functions
1. length()
2. substr()
3. contains()
4. lower()
5. regex()
6. can()
- Implement Custom Validation Rules in Variables

## Step-02: Learn Terraform Length Function
- The `terraform console` command provides an interactive console for evaluating expressions.
- [Terraform Console](https://www.terraform.io/docs/cli/commands/console.html)
- [Terraform Length Function](https://www.terraform.io/docs/language/functions/length.html)
```t
# Go to Terraform Console
terraform console

# Test length function
Template: length()

# String
length("hi")
length("hello")

# List
length(["a", "b", "c"]) 

# Map
length({"key" = "value"}) 
length({"key1" = "value1", "key2" = "value2" }) 
```

## Step-03: Learn Terraform SubString Function
- [Terraform Sub String Function](https://www.terraform.io/docs/language/functions/substr.html)
```t
# Go to Terraform Console
terraform console

# Test substr function
Template: substr(string, offset, length)
substr("stack simplify", 1, 4)
substr("stack simplify", 0, 6)
substr("stack simplify", 0, 1)
substr("stack simplify", 0, 0)
substr("stack simplify", 0, 10)
```

## Step-04: Learn Terraform contains() Function
- [Terraform Contains Function](https://www.terraform.io/docs/language/functions/contains.html)
```t
# Go to Terraform Console
terraform console

# Test contains() function
Template: contains(list, value)
contains(["a", "b", "c"], "a")
contains(["a", "b", "c"], "d")
contains(["eastus", "eastus2"], "westus2")
```

## Step-05: Learn Terraform lower() and upper() Function
- [Terraform Lower Function](https://www.terraform.io/docs/language/functions/lower.html)
- [Terraform Upper Function](https://www.terraform.io/docs/language/functions/upper.html)
```t
# Go to Terraform Console
terraform console

# Test lower() function
Template: lower("STRING")
lower("KALYAN REDDY")
lower("STACKSIMPLIFY")

# Test upper() function
Template: lower("string")
upper("kalyan reddy")
upper("stacksimplify")
```

## Step-06: Create Resource Group Variable with Validation Rules
- Understand and implement custom validation rules in variables
- **condition:** Defines the expression used to evaluate the Input Variable value. Must return either `true for valid`, or `false for invalid value`.
- **error_message:** Defines the error message displayed by Terraform when the condition expression returns false for an invalid value. Must be ended with period or question mark 
- **c2-variables.tf**
```t
# 4. Resource Group Location
variable "resoure_group_location" {
  description = "Resource Group Location"
  type = string
  default = "eastus"
  validation {
    condition  = var.resoure_group_location == "eastus" || var.resoure_group_location == "eastus2"
    #condition = contains(["eastus", "eastus2"], lower(var.resoure_group_location))
    error_message = "We only allow Resources to be created in eastus or eastus2 Locations."
  }  
}
```
## Step-07: Run Terraform commands
```t
# Initialize Terraform
terraform init

# Validate Terraform configuration files
terraform validate

# Format Terraform configuration files
terraform fmt

# Review the terraform plan
terraform plan

# Observation
1. When `resoure_group_location = "eastus"`, terraform plan should pass
2. When `resoure_group_location = "eastus2"`, terraform plan should pass
3. When `resoure_group_location = "westus"`, terraform plan should fail with error message as validation rule failed. 

# Uncomment validation rule with contains() function and comment previous one
condition = contains(["eastus", "eastus2"], lower(var.resoure_group_location))

# Review the terraform plan
terraform plan

# Observation
1. When `resoure_group_location = "eastus"`, terraform plan should pass
2. When `resoure_group_location = "eastus2"`, terraform plan should pass
3. When `resoure_group_location = "westus"`, terraform plan should fail with error message as validation rule failed. 
```
## Step-08: Learn Terraform regex() and can() Function
- [Terraform regex Function](https://www.terraform.io/docs/language/functions/regex.html)
- [Terraform can Function](https://www.terraform.io/docs/language/functions/can.html)
```t
# Go to Terraform Console
terraform console

# Test regex() function
Template: regex(pattern, string)
### TRUE CASES
regex("india$", "westindia")
regex("india$", "southindia")
can(regex("india$", "westindia"))
can(regex("india$", "southindia"))

### FAILURE CASES
regex("india$", "eastus")
can(regex("india$", "eastus"))
```

## Step-09: Update Resource Group Location Variable with can() and regex() function related Validation Rule
- Update Resource Group Location Variable with can() and regex() function related Validation Rule
```t
# 4. Resource Group Location
variable "resoure_group_location" {
  description = "Resource Group Location"
  type = string
  default = "eastus"
  validation {
    #condition  = var.resoure_group_location == "eastus" || var.resoure_group_location == "eastus2"
    #condition = contains(["eastus", "eastus2"], lower(var.resoure_group_location))
    #error_message = "We only allow Resources to be created in eastus or eastus2 Locations."
    condition = can(regex("india$", var.resoure_group_location))
    error_message = "We only allow Resources to be created in westindia and southindia locations."
  }  
}
```

## Step-10: Run Terraform commands
```t
# Validate Terraform configuration files
terraform validate

# Review the terraform plan
terraform plan

# Observation
1. When `resoure_group_location = "westinida"`, terraform plan should pass
2. When `resoure_group_location = "southindia"`, terraform plan should pass
3. When `resoure_group_location = "eastus2"`, terraform plan should fail with error message as validation rule failed. 
```

## Step-11: Clean-Up
```t
# Delete Files
rm -rf .terraform*

# Roll back to state as below for Students seamless demo before git check-in
# Change-1: c1-variables.tf
# 4. Resource Group Location
variable "resoure_group_location" {
  description = "Resource Group Location"
  type = string
  default = "eastus"
  validation {
    condition  = var.resoure_group_location == "eastus" || var.resoure_group_location == "eastus2"
    #condition = contains(["eastus", "eastus2"], lower(var.resoure_group_location))
    error_message = "We only allow Resources to be created in eastus or eastus2 Locations."
    #condition = can(regex("india$", var.resoure_group_location))
    #error_message = "We only allow Resources to be created in westindia and southindia locations."
  }  
}

# Change-2: terraform.tfvars
resoure_group_location = "eastus"
#resoure_group_location = "westus2"
#resoure_group_location = "westindia"
#resoure_group_location = "eastus2"
```


## References
- [Terraform Input Variables](https://www.terraform.io/docs/language/values/variables.html)



