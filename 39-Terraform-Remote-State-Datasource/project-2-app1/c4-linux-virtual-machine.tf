# Resource: Azure Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  name                = local.vm_name
  computer_name       = local.vm_name # Hostname of the VM
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  #resource_group_name = azurerm_resource_group.myrg.name
  #location            = azurerm_resource_group.myrg.location
  #network_interface_ids = [azurerm_network_interface.myvmnic.id]
  # Getting Data using Terraform Remote State Datasource from Project-1
  resource_group_name = data.terraform_remote_state.project1.outputs.resource_group_name
  location = data.terraform_remote_state.project1.outputs.resource_group_location
  network_interface_ids = [data.terraform_remote_state.project1.outputs.network_interface_id]
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
  os_disk {
    name = "osdisk${random_string.myrandom.id}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "83-gen2"
    version   = "latest"
  }
  custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")
  tags = local.common_tags
}


