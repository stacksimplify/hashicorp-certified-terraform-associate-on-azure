# Time Resource
# Wait for 90 seconds after creating the above Azure Virtual Machine Instance 
resource "time_sleep" "wait_90_seconds" {
  depends_on = [azurerm_linux_virtual_machine.mylinuxvm]
  create_duration = "90s"
}

# Terraform NULL RESOURCE
# Sync App1 Static Content to Webserver using Provisioners
resource "null_resource" "sync_app1_static" {
  depends_on = [time_sleep.wait_90_seconds]
  triggers = {
    always-update = timestamp()
  }

# Connection Block for Provisioners to connect to Azure VM Instance
  connection {
    type = "ssh"
    host = azurerm_linux_virtual_machine.mylinuxvm.public_ip_address
    user = azurerm_linux_virtual_machine.mylinuxvm.admin_username
    private_key = file("${path.module}/ssh-keys/terraform-azure.pem")
  }
# File Provisioner: Copies the app1 folder to /tmp
  provisioner "file" {
    source = "apps/app1"
    destination = "/tmp"
  }

# Remote-Exec Provisioner: Copies the /tmp/app1 folder to Apache Webserver /var/www/html directory
  provisioner "remote-exec" {
    inline = [
      "sudo cp -r /tmp/app1 /var/www/html"
    ]    
  }
}



