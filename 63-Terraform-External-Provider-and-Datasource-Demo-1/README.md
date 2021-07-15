---
title: Terraform External Provider and Datasource
description: Learn about Terraform External Provider and Datasource
---

## Step-01: Introduction
- [Terraform External Provider and Datasource](https://registry.terraform.io/providers/hashicorp/external/latest)

## Step-02: Pre-requisite Installs
- ssh-keygen
- jq
```t
# ssh-keygen
which ssh-keygen

# jq
which jq
brew install jq
```

## Step-03: ssh_key_generator.sh
- File Location: terraform-manifests/shell-scripts
```t
function error_exit() {
  echo "$1" 1>&2
  exit 1
}

function check_deps() {
  test -f $(which ssh-keygen) || error_exit "ssh-keygen command not found in path, please install it"
  test -f $(which jq) || error_exit "jq command not found in path, please install it"
}

function parse_input() {
  # jq reads from stdin so we don't have to set up any inputs, but let's validate the outputs
  eval "$(jq -r '@sh "export KEY_NAME=\(.key_name) KEY_ENVIRONMENT=\(.key_environment)"')"
  if [[ -z "${KEY_NAME}" ]]; then export KEY_NAME=none; fi
  if [[ -z "${KEY_ENVIRONMENT}" ]]; then export KEY_ENVIRONMENT=none; fi
}

function create_ssh_key() {
  script_dir=$(dirname $0)
  export ssh_key_file="${script_dir}/${KEY_NAME}-${KEY_ENVIRONMENT}"
  # echo "DEBUG: ssh_key_file = ${ssh_key_file}" 1>&2
  if [[ ! -f "${ssh_key_file}" ]]; then
    #ssh-keygen -m PEM -t rsa -b 4096 -N '' -f $ssh_key_file
    ssh-keygen -q -m PEM -t rsa -b 4096 -N '' -f $ssh_key_file
  fi
}

function produce_output() {
  public_key_contents=$(cat ${ssh_key_file}.pub)
  # echo "DEBUG: public_key_contents ${public_key_contents}" 1>&2
  private_key_contents=$(cat ${ssh_key_file} | awk '$1=$1' ORS='  \n')
  # echo "DEBUG: private_key_contents ${private_key_contents}" 1>&2
  # echo "DEBUG: private_key_file ${ssh_key_file}" 1>&2
  jq -n \
    --arg public_key "$public_key_contents" \
    --arg private_key "$private_key_contents" \
    --arg private_key_file "$ssh_key_file" \
    '{"public_key":$public_key,"private_key":$private_key,"private_key_file":$private_key_file}'
}

# main()
check_deps
# echo "DEBUG: received: $INPUT" 1>&2
parse_input
create_ssh_key
produce_output
```

## Step-04: Test Shell Script
```t
# Test Shell Script
echo '{"key_name": "terraformdemo", "key_environment": "dev"}' | ./ssh_key_generator.sh

# Verify the files created
File Location: terraform-manifests/shell-scripts/
1. terraformdemodev: Private key file created
2. terraformdemodev.pub: Public Key file created
```

## Step-05: c1-versions.tf
```t
# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }
    external = {
      source = "hashicorp/external"
      version = ">= 2.0"
    }       
  }
}

# Provider Block
provider "azurerm" {
 features {}          
}
```

## Step-06: c2-external-datasource.tf
```t
# External Datasource
data "external" "ssh_key_generator" {
  program = ["bash", "${path.module}/shell-scripts/ssh_key_generator.sh"]
  
  query = {
    key_name = "terraformdemo"
    key_environment = "dev"
  }
}
```

## Step-07: c2-external-datasource.tf - Outputs
- Terraform Outputs for the External Datasource. 
```t

# Outputs
output "public_key" {
  description = "public_key"
  value = data.external.ssh_key_generator.result.public_key
}

output "private_key" {
  description = "private_key"
  value = data.external.ssh_key_generator.result.private_key
}

output "private_key_file" {
  description = "private_key_file"
  value = data.external.ssh_key_generator.result.private_key_file 
}
```

## Step-08: Execute Terraform Commands
```t
# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Observation
1. Its just datasource, so either we execute terraform plan or apply, shell script "ssh_key_generator.sh" will be triggered  and Public and Private Keys are generated

# Terraform Apply (Optional)
terraform apply 
```

## Step-09: Clean-Up
```t
# Destroy Resources (Optional if terraform apply not executed)
terraform destroy -auto-approve 

# Delete Files
rm -rf .terraform* 
rm -rf terraform.tfstate*
```