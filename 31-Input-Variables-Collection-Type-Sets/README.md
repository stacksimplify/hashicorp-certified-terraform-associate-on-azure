---
title: Terraform Input Variables with Collection Type set
description: Learn about Terraform Input Variables with Collection Type set
---

## Step-01: Introduction
- Implement Collection Type `set` 
- What is set ?
### Usecase
- We will implement 4 environments (dev, qa, staging and prod) using single set of templates 
- We will use `for_each` and `set` combination to do that. 
- For each environment, following Resources will be created with single set of Terraform Configs
1. Resource Group
2. Virtual Network
3. Subnet
4. Public IP & Public Azure DNS Name
5. Network Interface
6. RHEL Virtual machine
7. Provision sample webserver in that RHEL VM

## Step-02: Implement complex type cosntructors like `list` 
- [Type Constraints](https://www.terraform.io/docs/language/expressions/types.html)
- [Input Variable Type set](https://www.terraform.io/docs/language/values/variables.html)
### sets: 
1. Sets do not support element ordering, meaning that traversing sets is not guaranteed to yield the same order each time and that their elements can not be accessed in a targeted way. 
- They contain unique elements repeated exactly once, and specifying the same element multiple times will result in them being coalesced with only one instance being present in the set.
- Declaring a set is similar to declaring a list, the only difference being the type of the variable:
```t
# 2. Environment Name
variable "environment" {
  description = "Environment Name"
  type = set(string)
  default = ["dev1", "qa1", "staging1", "prod1"]
}
```

## Step-03: c2-variables.tf
- Define the Input Variable Type `set` for environment.
```t
# 2. Environment Name
variable "environment" {
  description = "Environment Name"
  type = set(string)
  default = ["dev1", "qa1", "staging1", "prod1"]
}
```

## Step-04: terraform.tfvars
- Core focus on variables will be on `environment` variable of type `set`
- Rest variables are hard-coded in those respective resources. 
- Review `environment` variable in `terraform.tfvars`
```t
business_unit = "it"
environment = ["dev2", "myqa2", "staging2", "prod2"]
resoure_group_name = "rg"
```

## Step-05: c1-versions.tf
- As we are going to create 4 environments, our Random String Resource also need to be traversed in `for_each` loop to create 4 random strings per environment
- Create 4 Random Strings using `for_each` with `set` variable `var.environment`
```t
# Random String Resource
resource "random_string" "myrandom" {
  for_each = var.environment
  length = 6
  upper = false 
  special = false
  number = false   
}
```

## Step-06: c3-resource-group.tf
- Create 4 Resource Groups using `for_each` with `set` variable `var.environment`
```t
# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  for_each = var.environment
  name = "${var.business_unit}-${each.key}-${var.resoure_group_name}"
  location = var.resoure_group_location
}
```

## Step-07: c4-virtual-network.tf - Virtual Network
- Create 4 Virtual Networks using `for_each` with `set` variable `var.environment`
- One Virtual Network will be created in each Resource Group
```t
# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  for_each = var.environment
  name                = "${var.business_unit}-${each.key}-${var.virtual_network_name}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg[each.key].location
  resource_group_name = azurerm_resource_group.myrg[each.key].name
}
```

## Step-08: c4-virtual-network.tf - Subnet
- Create 4 Subnets using `for_each` with `set` variable `var.environment`
- One Subnet will be created in each Virtual Network
```t
# Create Subnet
resource "azurerm_subnet" "mysubnet" {
  for_each = var.environment
  #name                 = "mysubnet-1"
  name = "${var.business_unit}-${each.key}-${var.virtual_network_name}-mysubnet"
  resource_group_name  = azurerm_resource_group.myrg[each.key].name
  virtual_network_name = azurerm_virtual_network.myvnet[each.key].name
  address_prefixes     = ["10.0.2.0/24"]
}
```

## Step-09: c4-virtual-network.tf - Public IP
- Create 4 Public IPs using `for_each` with `set` variable `var.environment`
- One Public IP will be created and associated to respective Network Interface in each Virtual Network
```t
# Create Public IP Address
resource "azurerm_public_ip" "mypublicip" {
  for_each = var.environment
  #name                = "mypublicip-1"
  name = "${var.business_unit}-${each.key}-${var.virtual_network_name}-mypublicip"  
  resource_group_name = azurerm_resource_group.myrg[each.key].name
  location            = azurerm_resource_group.myrg[each.key].location
  allocation_method   = "Static"
  #domain_name_label = "app1-vm-${random_string.myrandom[each.key].id}"
   domain_name_label = "app1-vm-${each.key}-${random_string.myrandom[each.key].id}"
  tags = {
    environment = "Dev"
  }
}
```

## Step-10: c4-virtual-network.tf - Network Interface
- Create 4 Network Interfaces using `for_each` with `set` variable `var.environment`
- One Network Interface will be created and associated to respective Virtual Machine in each Virtual Network
```t
# Create Network Interface
resource "azurerm_network_interface" "myvmnic" {
  for_each = var.environment
  #name                = "vmnic"
  name = "${var.business_unit}-${each.key}-${var.virtual_network_name}-myvmnic"    
  location            = azurerm_resource_group.myrg[each.key].location
  resource_group_name = azurerm_resource_group.myrg[each.key].name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.mypublicip[each.key].id 
  }
}
```

## Step-11: c5-linux-virtual-machine.tf - Linux Virutal Machine
- Create 4 Virtual Machines using `for_each` with `set` variable `var.environment`
- One Virtual Machine will be created in each Virtual Network and associated to respective Network Interface
```t
# Resource: Azure Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  for_each = var.environment
  name                = "mylinuxvm-${each.key}"
  computer_name       = "devlinux-${each.key}" # Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg[each.key].name
  location            = azurerm_resource_group.myrg[each.key].location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  network_interface_ids = [azurerm_network_interface.myvmnic[each.key].id]
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
  os_disk {
    name = "osdisk${each.key}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    #disk_size_gb = 20
  }
  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "83-gen2"
    version   = "latest"
  }
  custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")
}
```

## Step-12: Execute Terraform Commands
```t
# Initialize Terraform
terraform init

# Validate Terraform configuration files
terraform validate

# Format Terraform configuration files
terraform fmt

# Review the terraform plan
terraform plan 

# Terraform Apply
terraform apply -auto-approve

# Observation
1. Verify 4 Random Resources created
2. Verify 4 Resource Groups created
3. Verify 4 Virtual Networks created
4. Verify 4 Subnets created
5. Verify 4 Network Interfaces created
6. Verify 4 Virtual Machines created
7. Verify 4 public ips created
8. Verify Disks for Virtual Machines - 4 osdisk created

# Access Sample App
## Root Context
http://app1-vm-dev2-yjedfa.eastus.cloudapp.azure.com
http://app1-vm-myqa2-ysutkd.eastus.cloudapp.azure.com
http://app1-vm-prod2-qoaqpq.eastus.cloudapp.azure.com
http://app1-vm-staging2-pcyeuc.eastus.cloudapp.azure.com

## App1 Context
http://app1-vm-dev2-yjedfa.eastus.cloudapp.azure.com/app1/index.html
http://app1-vm-myqa2-ysutkd.eastus.cloudapp.azure.com/app1/index.html
http://app1-vm-prod2-qoaqpq.eastus.cloudapp.azure.com/app1/index.html
http://app1-vm-staging2-pcyeuc.eastus.cloudapp.azure.com/app1/index.html

## metadata.html
http://app1-vm-dev2-yjedfa.eastus.cloudapp.azure.com/app1/metadata.html
http://app1-vm-myqa2-ysutkd.eastus.cloudapp.azure.com/app1/metadata.html
http://app1-vm-prod2-qoaqpq.eastus.cloudapp.azure.com/app1/metadata.html
http://app1-vm-staging2-pcyeuc.eastus.cloudapp.azure.com/app1/metadata.html
```


## Step-10: Clean-Up 
```t
# Destroy Resources
terraform destroy -auto-approve

# Delete Files
rm -rf .terraform* 
rm -rf terraform.tfstate*
```

## References
- [Terraform Input Variables](https://www.terraform.io/docs/language/values/variables.html)



