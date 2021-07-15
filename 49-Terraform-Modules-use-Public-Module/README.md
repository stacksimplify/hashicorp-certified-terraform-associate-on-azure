---
title: Terraform Modules use Public Modules
description: Learn to use Terraform Public Modules
---

## Step-01: Introduction
1. Introduction - Module Basics  
  - Root Module
  - Child Module
  - Published Modules (Terraform Registry)

2. Module Basics 
  - Defining a Child Module
    - Source (Mandatory)
    - Version
    - Meta-arguments (count, for_each, providers, depends_on, )
    - Accessing Module Output Values
    - Tainting resources within a module

3. [Module Sources](https://www.terraform.io/docs/language/modules/sources.html)    

## Step-02: Defining a Child Module
- We need to understand about the following
1. **Module Source (Mandatory):** To start with we will use Terraform Registry
2. **Module Version (Optional):** Recommended to use module version
- [Azure VNET Terraform Module](https://registry.terraform.io/modules/Azure/vnet/azurerm/latest)  
- We are going to use the previous example and in that we will remove Virtual Network and Subnet Terraform Resources and use a Virtual Network Public Registry module.
- c5-virrtual-network.tf
```t
# Create Virtual Network and Subnets using Terraform Public Registry Module
module "vnet" {
  source              = "Azure/vnet/azurerm"
  version = "2.5.0"
  vnet_name = local.vnet_name
  resource_group_name = azurerm_resource_group.myrg.name
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]

  subnet_service_endpoints = {
    subnet2 = ["Microsoft.Storage", "Microsoft.Sql"],
    subnet3 = ["Microsoft.AzureActiveDirectory"]
  }
  tags = {
    environment = "dev"
    costcenter  = "it"
  }
  depends_on = [azurerm_resource_group.myrg]
}
```

## Step-03: Changes to Network Interface
- c5-virtual-network.tf
```t
# Create Network Interface
resource "azurerm_network_interface" "myvmnic" {
  name                = local.nic_name
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    #subnet_id                     = azurerm_subnet.mysubnet.id    
    subnet_id                     = module.vnet.vnet_subnets[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.mypublicip.id 
  }
  tags = local.common_tags
}
```

## Step-04: c6-linux-virtual-machine.tf
- No changes to Linux Virtual Machine.
- We reference the Network Interface only in VM Resource, so due to VNET change, no changes required in VM Resource.

## Step-05: c7-outputs.tf
- Define Virtual Network Module Outputs
```t
# Output Values - Virtual Network
output "virtual_network_name" {
  description = "Virutal Network Name"
  #value = azurerm_virtual_network.myvnet.name 
  value = module.vnet.vnet_name
}
output "virtual_network_id" {
  description = "Virutal Network ID"
  value = module.vnet.vnet_id
}
output "virtual_network_subnets" {
  description = "Virutal Network Subnets"
  value = module.vnet.vnet_subnets
}
output "virtual_network_location" {
  description = "Virutal Network Location"
  value = module.vnet.vnet_location
}
output "virtual_network_address_space" {
  description = "Virutal Network Address Space"
  value = module.vnet.vnet_address_space
}
```

## Step-06: Execute Terraform Commands
```t
# Terraform Init
terraform init

# Terraform Validate
terraform validate

# Terraform Format
terraform fmt

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-apporve

# Verify 
1) Verify in Azure Portal console , all the resources should be created.
http://<Public-IP-VM>
http://<Public-IP-VM>/app1
http://<Public-IP-VM>/app1/metadata.html
```

## Step-07: Tainting Resources in a Module
- The **taint command** can be used to taint specific resources within a module
- **Very Very Important Note:** It is not possible to taint an entire module. Instead, each resource within the module must be tainted separately.
```t
# List Resources from State
terraform state list

# Taint a Resource
terraform taint <RESOURCE-NAME>
terraform taint module.vnet.azurerm_subnet.subnet[2]

# Terraform Plan
terraform plan
Observation: 
1. Subnet2 will be destroyed and re-created

# Terraform Apply
terraform apply -auto-approve
```

## Step-08: Clean-Up Resources & local working directory
```t
# Terraform Destroy
terraform destroy -auto-approve

# Delete Terraform files 
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## Step-09: Meta-Arguments for Modules
- Meta-Argument concepts are going to be same as how we learned during Resources section.
1. count
2. for_each
3. providers
4. depends_on
5. lifecycle
- [Meta-Arguments for Modules](https://www.terraform.io/docs/language/modules/syntax.html#meta-arguments)


## Step-10: Discuss about Module Sources
- [Module Sources](https://www.terraform.io/docs/language/modules/sources.html)   