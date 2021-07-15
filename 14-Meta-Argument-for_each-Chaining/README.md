---
title: Terraform Resource Meta-Argument for_each Chaining
description: Learn Terraform Resource Meta-Argument for_each Chaining
---
## Step-01: Introduction
- Understand about Meta-Argument `for_each`
- Implement `for_each` Chaining
- Because a resource using `for_each` appears as a `map of objects` or `set of strings` when used in expressions elsewhere, you can directly use one resource as the `for_each of another in situations` where there is a `one-to-one relationship` between two sets of objects.
- In our case, we will use the `azurerm_network_interface.myvmnic` resource directly in `azurerm_linux_virtual_machine.mylinuxvm` Resource. 

## Step-02: Review Terarform Manifests
- Copy the `terraform-manifests` from Section `11-Meta-Argument-count\terraform-manifests-v2` and re-implement this usecase using `for_each`. 
- Also apply `for_each` chaining concept
1. c1-versions.tf
2. c2-resource-group.tf
3. c3-virtual-machine.tf: Changes for Public IP and Network Interface Resources with `for_each` same argument in both resources.
4. c4-linux-virtual-machine.tf: `for_each` using Network Interface Resource

## Step-03: c3-virtual-machine.tf -  Azure Public IP Resource
```t
# Create Azure Public IP Address
resource "azurerm_public_ip" "mypublicip" {
  #count = 2  
  for_each = toset(["vm1", "vm2"])
  name                = "mypublicip-${each.key}"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label = "app1-${each.key}-${random_string.myrandom.id}"  
}
```

## Step-04: c3-virtual-machine.tf - Azure Network Interface Resource
```t
# Create Network Interface
resource "azurerm_network_interface" "myvmnic" {
  #count = 2
  for_each = toset(["vm1", "vm2"])  
  name                = "vmnic-${each.key}"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id = element(azurerm_public_ip.mypublicip.*.id, each.key)
    public_ip_address_id = azurerm_public_ip.mypublicip[each.key].id
  }
}
```

## Step-05: c4-linux-virtual-machine.tf
```t
# Resource: Azure Linux Virtual Machine

resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  #count = 2
  #for_each = toset(["vm1", "vm2"])  
  for_each = azurerm_network_interface.myvmnic #for_each chaining
  # Define Explicit Dependency that if VM Nic exists, then only create VM
  depends_on = [ azurerm_network_interface.myvmnic ]
  name                = "mylinuxvm-${each.key}"
  computer_name       = "devlinux-${each.key}" # Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  #network_interface_ids = [element(azurerm_network_interface.myvmnic.*.id, each.key)]
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

## Step-06: Observe Linux Virtual Machine for_each Argument
- In `azurerm_linux_virtual_machine` resource we are using the `for_each` argument by referring to Network Interface Resource named `azurerm_network_interface.myvmnic`. This is called `for_each` chaining. 
```t
# for_each chaining
  for_each = azurerm_network_interface.myvmnic 
```

## Step-07: Execute Terraform Commands
```t
# Terraform Init
terraform init

# Terraform Validate
terraform validate

# Terraform Format
terraform fmt

# Terraform Plan
terraform plan
Observation: 
1) 2 Public IP, 2 Network Interface and 2 Linux VM Resources will be generated in plan
2) Review Resource Names ResourceType.ResourceLocalName[each.key]
3) Review Resource Names

# Terarform Apply
terraform apply
 
# Verify
1. Azure Resource Group
2. Azure Virtual Network
3. Azure Subnet
4. Azure Public IP - 2 Resources created as specified in count
5. Azure Network Interface - 2 Resources created as specified in count
6. Azure Linux Virtual Machine - - 2 Resources created as specified in count

# Access Application
http://<PUBLIC_IP-1>
http://<PUBLIC_IP-2>
```

## Step-08: Destroy Terraform Resources
```t
# Destroy Terraform Resources
terraform destroy

# Remove Terraform Files
rm -rf .terraform*
rm -rf terraform.tfstate*
```
