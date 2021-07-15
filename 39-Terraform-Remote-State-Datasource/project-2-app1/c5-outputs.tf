# 1. Output Values - Virtual Machine
output "vm_public_ip_address" {
  description = "My Virtual Machine Public IP"
  value = azurerm_linux_virtual_machine.mylinuxvm.public_ip_address
}

# 2. Output Values - Virtual Machine Resource Group Name
output "vm_resource_group_name" {
  description = "My Virtual Machine Resource Group Name"
  value = azurerm_linux_virtual_machine.mylinuxvm.resource_group_name
}

# 3. Output Values - Virtual Machine Location
output "vm_resource_group_location" {
  description = "My Virtual Machine Location"
  value = azurerm_linux_virtual_machine.mylinuxvm.location
}

# 4. Output Values - Virtual Machine Network Interface ID
output "vm_network_interface_ids" {
  description = "My Virtual Machine Network Interface IDs"
  value = [azurerm_linux_virtual_machine.mylinuxvm.network_interface_ids]
}


