---
title: Terraform File Provisioner
description: Learn Terraform File Provisioner
---

## Step-00: Provisioner Concepts
- Generic Provisioners
1. [file](https://www.terraform.io/docs/language/resources/provisioners/file.html)
2. local-exec
3. remote-exec
- Provisioner Timings
  - Creation-Time Provisioners (by default)
  - Destroy-Time Provisioners  
- Provisioner Failure Behavior
  - continue
  - fail
- [Provisioner Connections](https://www.terraform.io/docs/language/resources/provisioners/connection.html)
- Provisioner Without a Resource  (Null Resource)

## Pre-requisites - SSH Keys
- Create SSH Keys for Azure VM Instance if not created
```t
# Create Folder
cd terraform-manifests/
mkdir ssh-keys

# Create SSH Key
cd ssh-ekys
ssh-keygen \
    -m PEM \
    -t rsa \
    -b 4096 \
    -C "azureuser@myserver" \
    -f terraform-azure.pem 
Important Note: If you give passphrase during generation, during everytime you login to VM, you also need to provide passphrase.

# List Files
ls -lrt ssh-keys/

# Files Generated after above command 
Public Key: terraform-azure.pem.pub -> Rename as terraform-azure.pub
Private Key: terraform-azure.pem

# Permissions for Pem file
chmod 400 terraform-azure.pem
```  
- Connection Block for provisioners uses this to connect to newly created Azure VM instance to copy files using `file provisioner`, execute scripts using `remote-exec provisioner`

## Step-01: Introduction
- Understand about [File Provisioners](https://www.terraform.io/docs/language/resources/provisioners/file.html)
- Create [Provisioner Connections block](https://www.terraform.io/docs/language/resources/provisioners/connection.html) required for File Provisioners
- We will also discuss about **Creation-Time Provisioners (by default)**
- Understand about Provisioner Failure Behavior
  - continue
  - fail
- Discuss about Destroy-Time Provisioners    


## Step-02: File Provisioner & Connection Block
- Understand about file provisioner & Connection Block
- **Connection Block**
1. We can have connection block inside resource block for all provisioners 
2. [or] We can have connection block inside a provisioner block for that respective provisioner
- **Self Object**
1. **Important Technical Note:** Resource references are restricted here because references create dependencies. Referring to a resource by name within its own block would create a dependency cycle.
2. Expressions in provisioner blocks cannot refer to their parent resource by name. Instead, they can use the special **self object.**
3. The **self object** represents the provisioner's parent resource, and has all of that resource's attributes. 
```t
  # Connection Block for Provisioners to connect to Azure Virtual Machine
  connection {
    type = "ssh"
    host = self.public_ip_address # Understand what is "self"
    user = self.admin_username
    password = ""
    private_key = file("${path.module}/ssh-keys/terraform-azure.pem")
  }  
```

## Step-03: Create multiple provisioners of various types
- **Creation-Time Provisioners:** 
- By default, provisioners run when the resource they are defined within is created. 
- `Creation-time provisioners` are only run during creation, not during updating or any other lifecycle. 
- They are meant as a means to perform bootstrapping of a system.
- If a `creation-time provisioner` fails, the resource is marked as `tainted`. 
- A tainted resource will be planned for `destruction and recreation` upon the next `terraform apply`.
- Terraform does this because a `failed provisioner` can leave a resource in a semi-configured state. 
- Because Terraform cannot reason about what the provisioner does, the only way to ensure proper creation of a resource is to recreate it. This is `tainting`.
- You can change this behavior by setting the `on_failure` attribute, which is covered in detail below.

```t
 # File Provisioner-1: Copies the file-copy.html file to /tmp/file-copy.html
  provisioner "file" {
    source      = "apps/file-copy.html"
    destination = "/tmp/file-copy.html"
  }

  # File Provisioner-2: Copies the string in content into /tmp/file.log
  provisioner "file" {
    content     = "VM Host Name: ${self.computer_name}" # Understand what is "self"
    destination = "/tmp/file.log"
  }

  # File Provisioner-3: Copies the app1 folder to /tmp - FOLDER COPY
  provisioner "file" {
    source      = "apps/app1"
    destination = "/tmp"
  }

  # File Provisioner-4: Copies all files and folders in apps/app2 to /tmp - CONTENTS of FOLDER WILL BE COPIED
  provisioner "file" {
    source      = "apps/app2/" # when "/" at the end is added - CONTENTS of FOLDER WILL BE COPIED
    destination = "/tmp"
  }

```

## Step-04: Create Resources using Terraform commands

```t
# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Format
terraform fmt

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-approve

# Verify - Login to Azure Virtual Machine Instance
ssh -i ssh-keys/terraform-azure.pem azureuser@IP_ADDRESSS_OF_YOUR_VM
ssh -i ssh-keys/terraform-azure.pem azureuser@20.185.30.127
Verify /tmp for all files copied
cd /tmp
ls -lrta /tmp

# Clean-up
terraform destroy -auto-approve
rm -rf terraform.tfsate*
Observation: 
Q1: Why do we need to destroy and move with next steps?
A1: 
1. Provisioners can be created during resource creation-time or destroy-time. 
2. With that said, we need to test failure case of a provisioner which will faill "terraform apply". 
3. We will understand that in next few steps. 
```

## Step-05: Failure Behavior: Understand Decision making when provisioner fails (continue / fail)
- By default, provisioners that fail will also cause the Terraform apply itself to fail. The on_failure setting can be used to change this. The allowed values are:
1. **continue:** Ignore the error and continue with creation or destruction.
2. **fail:** (Default Behavior) Raise an error and stop applying (the default behavior). If this is a creation provisioner, taint the resource.  
- Try copying a file to Apache static content folder "/var/www/html" using file-provisioner
- This will fail because, the user you are using to copy these files is "azureuser" for Azure linux vm. This user don't have access to folder "/var/www/html/" top copy files. 
- We need to use sudo to do that. 
- All we know is we cannot copy it directly, but we know we have already copied this file in "/tmp" using file provisioner
- **Try two scenarios**
1. No `on_failure` attribute (Same as `on_failure = fail`) - default what happens It will Raise an error and stop applying. If this is a creation provisioner, it will taint the resource.
2. When `on_failure = continue`, will continue creating resources
3. **Verify:**  Verify `terraform.tfstate` for  `"status": "tainted"`
```t
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
```
### Step-05-01: Fail Case
```t
# Test-1: Without on_failure attribute which will fail terraform apply
 # Copies the file-copy.html file to /var/www/html/file-copy.html
  provisioner "file" {
    source      = "apps/file-copy.html"
    destination = "/var/www/html/file-copy.html"
   }
# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-approve   

# Verify:  
Verify terraform.tfstate for  "status": "tainted"

## Sample Failure Log
azurerm_linux_virtual_machine.mylinuxvm: Provisioning with 'file'...
azurerm_linux_virtual_machine.mylinuxvm: Still creating... [3m0s elapsed]
╷
│ Error: file provisioner error
│ 
│   with azurerm_linux_virtual_machine.mylinuxvm,
│   on c6-linux-virtual-machine.tf line 71, in resource "azurerm_linux_virtual_machine" "mylinuxvm":
│   71:   provisioner "file" {
│ 
│ Upload failed: scp: /var/www/html/file-copy.html: Permission denied
╵
```
### Step-05-02: Continue Case
- Uncomment `on_failure  = continue`
```t
# Test-2: With on_failure = continue
 # Copies the file-copy.html file to /var/www/html/file-copy.html
  provisioner "file" {
    source      = "apps/file-copy.html"
    destination = "/var/www/html/file-copy.html"
    on_failure  = continue 
   }
# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-approve

# Verify
1. Login to Azure VM Instance
ssh -i ssh-keys/terraform-azure.pem azureuser@<VM-PUBLIC-IP>
ssh -i ssh-keys/terraform-azure.pem azureuser@20.102.55.82


2. Verify /tmp - for all files copied
3. Verify /var/www/html - file-copy.html should not be copied
4. File Provisioner didn't do job of file copy but still it didn't get fail due to the fact that we used "on_failure  = continue"
```

## Step-06: Clean-Up Resources & local working directory
```t
# Terraform Destroy
terraform destroy -auto-approve

# Delete Terraform files 
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## Step-07: Roll back change for Student seamless demo
```t
# c6-linux-virtual-machine.tf
Comment last File Provisioner so that it will be enabled when required by students during the step by step process.
```

## Step-07: Destroy Time Provisioners
- Discuss about this concept
- [Destroy Time Provisioners](https://www.terraform.io/docs/language/resources/provisioners/syntax.html#destroy-time-provisioners)
- Inside a provisioner when you add this statement `when    = destroy` it will provision this during the resource destroy time
```t
resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  # ...

  provisioner "local-exec" {
    when    = destroy 
    command = "echo 'Destroy-time provisioner'"
  }
}
```