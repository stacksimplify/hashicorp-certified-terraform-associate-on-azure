---
title: Terraform External Provider and Datasource
description: Learn about Terraform External Provider and Datasource
---

## Step-01: Introduction
- [Terraform External Provider and Datasource](https://registry.terraform.io/providers/hashicorp/external/latest)
- We understoon about external provider and datasource in previous demo.
- Here we will integrate it with Azure Virtual machine Terraform Resource

## Step-02: Review Terraform Configs
- Files were copied from `11-01-Terraform-Azure-Linux-Virtual-Machine`
1. c1-versions.tf
2. c2-resource-group.tf
3. c3-virtual-network.tf
4. c4-linux-virtual-machine.tf
5. c5-external-datasource.tf
6. app-scripts/app1-cloud-init.txt
7. shell-scripts/ssh_key_generator.sh

## Step-03: c4-linux-virtual-machine.tf
- `public_key` argument will be changed with External Datasource Value. 
```t
# Before
  admin_ssh_key {
    username = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
# After
  admin_ssh_key {
    username = "azureuser"
    public_key = data.external.ssh_key_generator.result.public_key
  }
```


## Step-04: Execute Terraform Commands
```t
# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Observation
1. Its just datasource, so either we execute terraform plan or apply, shell script "ssh_key_generator.sh" will be triggered  and Public and Private Keys are generated

# Terraform Apply 
terraform apply -auto-approve

# Connect to VM (should be successful)
chmod 400 shell-scripts/terraformdemo-dev 
ssh -i shell-scripts/terraformdemo-dev azureuser@<PUBLIC-IP-OF-VM>

# Access Sample App
http://<PUBLIC-IP-OF-VM>
```

## Step-05: Clean-Up
```t
# Destroy Resources 
terraform destroy -auto-approve 

# Delete Files
rm -rf .terraform* 
rm -rf terraform.tfstate*
```