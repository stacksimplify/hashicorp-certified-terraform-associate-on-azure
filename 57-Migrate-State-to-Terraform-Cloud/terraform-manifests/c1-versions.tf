# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }  
    random = {
      source = "hashicorp/random"
      version = ">= 3.0"
    }           
  }
# Enable the below Backend block during Step-05
 /*
  backend "remote" {
    hostname      = "app.terraform.io"
    organization  = "hcta-azure-demo1"  # Organization should already exists in Terraform Cloud
    workspaces {
      name = "state-migration-demo1" 
      # Two cases: 
      # Case-1: If workspace already exists, should not have any state files in states tab
      # Case-2: If workspace not exists, during migration it will get created
    }
  }  
*/
}
