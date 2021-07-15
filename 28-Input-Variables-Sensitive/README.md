---
title: Terraform Sensitive Input Variables 
description: Learn about Terraform Sensitive Input Variables 
---

## Step-01: Introduction
- Variables of Type Boolean
- Variables of Type Number
- Variables of Type Sensitive
- Protect Sensitive Input Variables

## Step-02: Protect Sensitive Input Variables
- [Vault Provider](https://learn.hashicorp.com/tutorials/terraform/secrets-vault?in=terraform/secrets)
- When using environment variables to set sensitive values, keep in mind that those values will be in your environment and command-line history
`Example: export TF_VAR_db_username=admin TF_VAR_db_password=adifferentpassword`
- When you use sensitive variables in your Terraform configuration, you can use them as you would any other variable. 
- Terraform will `redact` these values in command output and log files, and raise an error when it detects that they will be exposed in other ways.
- **Important Note-1:** Never check-in `secrets.tfvars` to git repositories
- **Important Note-2:** Terraform state file contains values for these sensitive variables `terraform.tfstate`. You must keep your state file secure to avoid exposing this data.

## Step-03: c1-versions.tf
- We are not using any random resource in this demo.
- So removed both the Random Provider and Random Resource
```t
# Terraform Block
terraform {
  required_version = ">= 0.15"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }
  }
}

# Provider Block
provider "azurerm" {
 features {}          
}
```

## Step-04: c2-variables.tf
- We are going to add 5 DB variables with following combinations
1. Azure MySQL DB Name (Variable Type: String)
2. Azure MySQL DB Username (Variable Type: Sensitive String)
3. Azure MySQL DB Password (Variable Type: Sensitive String)
4. Azure MySQL DB Storage in MB (Variable Type: Number)
5. Azure MYSQL DB auto_grow_enabled (Variable Type: Boolean)
```t
# Input Variables
# 6. Azure MySQL DB Name (Variable Type: String)
variable "db_name" {
  description = "Azure MySQL Database DB Name"
  type        = string
}

# 7. Azure MySQL DB Username (Variable Type: Sensitive String)
variable "db_username" {
  description = "Azure MySQL Database Administrator Username"
  type        = string
  sensitive   = true
}

# 8. Azure MySQL DB Password (Variable Type: Sensitive String)
variable "db_password" {
  description = "Azure MySQL Database Administrator Password"
  type        = string
  sensitive   = true
}

# 9. Azure MySQL DB Storage in MB (Variable Type: Number)
variable "db_storage_mb" {
  description = "Azure MySQL Database Storage in MB"
  type = number
}

# 10. Azure MYSQL DB auto_grow_enabled (Variable Type: Boolean)
variable "db_auto_grow_enabled" {
  description = "Azure MySQL Database - Enable or Disable Auto Grow Feature"
  type = bool
}
```

## Step-05: c4-azure-mysql-database.tf
- Create [Azure MySQL Database Server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_server)
```t
# Azure MySQL Database Server
resource "azurerm_mysql_server" "mysqlserver" {
  name                = "${var.business_unit}-${var.environment}-${var.db_name}" 
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  administrator_login          = var.db_username
  administrator_login_password = var.db_password

  sku_name   = "B_Gen5_2"
  storage_mb = var.db_storage_mb
  version    = "8.0"

  auto_grow_enabled                 = var.db_auto_grow_enabled
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = false
  #ssl_minimal_tls_version_enforced  = "TLS1_2"
  tags = var.common_tags
}
```

## Step-06: c4-azure-mysql-database.tf
- Create [Azure MySQL Database Schema](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_database) inside Azure MySQL Database Server
```t
# Create Database inside Azure MySQL Database Server
resource "azurerm_mysql_database" "webappdb1" {
  name                = "webappdb1"
  resource_group_name = azurerm_resource_group.myrg.name
  server_name         = azurerm_mysql_server.mysqlserver.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}
```

## Step-07: terraform.tfvars
- Discuss about `terraform.tfvars` file
```t
# Generic Variables
business_unit = "it"
environment = "dev"

# Resource Group Variables
resoure_group_name = "rg"
resoure_group_location = "eastus"

# DB Variables
db_name = "mydb101"
db_storage_mb = 5120
db_auto_grow_enabled = true
```

## Step-08: secrets.tfvars
```t
# Database Secure Variables
db_username = "mydbadmin"
db_password = "H@Sh1CoR3!"
```

## Step-09: Execute Terraform Command
```t
# Initialize Terraform
terraform init

# Validate Terraform configuration files
terraform validate

# Format Terraform configuration files
terraform fmt

# Review the terraform plan
terraform plan -var-file="secrets.tfvars"
Observation:
1. Review the values for db_username and db_password in azurerm_mysql_server resource
2. You should see they were marked as sensitive

# Sample Output
  + resource "azurerm_mysql_server" "mysqlserver" {
      + administrator_login               = (sensitive)
      + administrator_login_password      = (sensitive value)

# Create Resources
terraform apply -var-file="secrets.tfvars"

# Verify Terraform State files
grep administrator_login terraform.tfstate
grep administrator_login_password terraform.tfstate 
Observation:
1. Both values will be in clear-text in terraform.tfstate file
2. Which means we should not check-in "terraform.tfstate" files to git repos for security reasons
3. Same applies to secrets.tfvars file too. 
```

## Step-10: Verify and Connect to MySQL DB
```t
# Azure Mgmt Console (if you have mysql client installed on your desktop)
1. Verify the Azure MySQL Database on Azure Mgmt Console
2. Go to Settings -> Connection Security -> Add Client IP (Add your Public IP) -> Click on Save
3. Run MySQL Commands and Verify "webappdb1" schema got created
Template: mysql -h <Azure DB Server Name> -u <Server admin login name> -pH@Sh1CoR3!
kalyan@MyLocalDesktop:~$ mysql -h it-dev-mydb101.mysql.database.azure.com -u mydbadmin@it-dev-mydb101 -pH@Sh1CoR3!
mysql> show schemas;
mysql> exit

# Azure Mgmt Console - Azure Shell
1. Login to Azure shell
2. Run mysql command
Template: mysql -h <Azure DB Server Name> -u <Server admin login name> -pH@Sh1CoR3!
stack@Azure:~$ mysql -h it-dev-mydb101.mysql.database.azure.com -u mydbadmin@it-dev-mydb101 -pH@Sh1CoR3!
3. It should display public IP of Azure shell
4. Go ahead and add that in Azure DB Firewall Rules
5. Go to Settings -> Connection Security -> Add Client IP (Azure Shell Public IP) -> Click on Save
6. Run the mysql connect command
Template: mysql -h <Azure DB Server Name> -u <Server admin login name> -pH@Sh1CoR3!
stack@Azure:~$ mysql -h it-dev-mydb101.mysql.database.azure.com -u mydbadmin@it-dev-mydb101 -pH@Sh1CoR3!
7.  Run show schemas; command and Verify our "webappdb1" schema created or not 
mysql> show schemas;
mysql> exit
```

## Step-11: Clean-Up
```t
# Destroy Resources
terraform destroy -var-file="secrets.tfvars"

# Clean-Up
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## Step-12: Variable Definition Precedence
- Discuss about [Terraform Variable Definition Precedence](https://www.terraform.io/docs/language/values/variables.html#variable-definition-precedence)


## References
- [Terraform Input Variables](https://www.terraform.io/docs/language/values/variables.html)



