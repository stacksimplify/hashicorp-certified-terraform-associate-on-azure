# Resource: Azure Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  name                = local.vm_name
  computer_name       = local.vm_name # Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  network_interface_ids = [ azurerm_network_interface.myvmnic.id ]
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
    host = self.public_ip_address
    user = self.admin_username
    private_key = file("${path.module}/ssh-keys/terraform-azure.pem")
  }  
  # File Provisioner-1: Copies the file-copy.html file to /tmp/file-copy.html
  provisioner "file" {
    source = "apps/file-copy.html"
    destination = "/tmp/file-copy.html"
  }
  # File Provisioner-2: Copies the string in content into /tmp/file.log
  provisioner "file" {
    content = "VM Host name: ${self.computer_name}"
    destination = "/tmp/file.log"
  }
  # File Provisioner-3: Copies the app1 folder to /tmp - FOLDER COPY
  provisioner "file" {
    source = "apps/app1"
    destination = "/tmp"
  }
  # File Provisioner-4: Copies all files and folders in apps/app2 to /tmp - CONTENTS of FOLDER WILL BE COPIED
  provisioner "file" {
    source = "apps/app2/"
    destination = "/tmp"
  }

/*
# Enable this during Step-05-01 Test-1
 # File Provisioner-5: Copies the file-copy.html file to /var/www/html/file-copy.html where "azureuser" don't have permission to copy
 # This provisioner will fail but we don't want to taint the resource, we want to continue on_failure
  provisioner "file" {
    source      = "apps/file-copy.html"
    destination = "/var/www/html/file-copy.html"
    #on_failure  = continue  # Enable this during Step-05-01 Test-2
   } 
*/   
}


