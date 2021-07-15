# Resource: Azure Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  name                = local.vm_name
  computer_name       = local.vm_name # Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.myvmnic.id
  ]
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

# PLAY WITH /tmp folder in Virtual Machine with File Provisioner
  # Connection Block for Provisioners to connect to Azure Virtual Machine
  connection {
    type = "ssh"
    host = self.public_ip_address # Understand what is "self"
    user = self.admin_username
    private_key = file("${path.module}/ssh-keys/terraform-azure.pem")
  }  

# File-Provisioner-1: Copies the file-copy.html file to /tmp/file-copy.html
  provisioner "file" {
    source      = "apps/file-copy.html"
    destination = "/tmp/file-copy.html"
  }

# Remote-exec Provisioner-1: Copies the file to Apache Webserver /var/www/html directory
  provisioner "remote-exec" {
    inline = [
      "sleep 120", # Will sleep for 120 seconds to ensure Apache webserver is provisioned using custom_data
      "sudo cp /tmp/file-copy.html /var/www/html"
    ]
  }

}


