---
title: Terraform Manage Providers
description: Learn to Manage Terraform Providers
---


## Step-01: Introduction
- [Manage Terraform Providers](https://www.terraform.io/docs/cli/plugins/index.html)
1. terraform providers
2. terraform version
3. terraform providers lock
4. terraform providers mirror
5. terraform providers schema -json 


## Step-02: Command: terraform providers
- The `terraform providers` command shows information about the provider requirements of the configuration in the current working directory.
```t
# Change Directory
cd terraform-manifests/

# Terraform Providers
terraform providers

# Sample Output
Kalyans-Mac-mini:terraform-manifests kalyanreddy$ terraform providers

Providers required by configuration:
.
├── provider[registry.terraform.io/hashicorp/external] >= 2.0.0
├── provider[registry.terraform.io/hashicorp/azurerm] >= 2.0.0
└── provider[registry.terraform.io/hashicorp/random] >= 3.0.0

Kalyans-Mac-mini:terraform-manifests kalyanreddy$ 
```

## Step-03: Command: terraform version
- The `terraform version` displays the current version of Terraform and all installed plugins.
```t
# Change Directory
cd terraform-manifests/

# Terraform Version
terraform version

# Sample Output - Before terraform init
Kalyans-Mac-mini:terraform-manifests kalyanreddy$ terraform version
Terraform v1.0.0
Kalyans-Mac-mini:terraform-manifests kalyanreddy$ 

# Terraform Initialize
terraform init

# Terraform Version
terraform version

# Sample Output - After terraform init
Kalyans-Mac-mini:terraform-manifests kalyanreddy$ terraform version
Terraform v1.0.0
on darwin_amd64
+ provider registry.terraform.io/hashicorp/azurerm v2.65.0
+ provider registry.terraform.io/hashicorp/external v2.1.0
+ provider registry.terraform.io/hashicorp/random v3.1.0
Kalyans-Mac-mini:terraform-manifests kalyanreddy$ 
```

## Step-04: Command: terraform providers lock
- The `terraform providers lock` consults upstream registries (by default) in order to write provider dependency information into the `dependency lock file`.
- :warning: The terraform providers lock command prints information about what it has fetched and whether each package was signed using a cryptographic signature, but it cannot automatically verify that the providers are trustworthy and that they comply with your local system policies or relevant regulations. Review the signing key information in the output to confirm that you trust all of the signers before committing the updated lock file to your version control system.
```t
# Change Directory
cd terraform-manifests/

# Terraform Providers lock
terraform providers lock
Observation: 
1. This command will fetch the providers information and create the file named ".terraform.lock.hcl", if we run it for first time in Terraform Working Directory

# Terraform Initialize
terraform init
Observation:
1. This command will reference the ".terraform.lock.hcl" file and download the equivalent providers as per that file. 
```

## Step-05: Command: terraform providers lock for all supported platforms
1. Windows: General use will be developers using Terraform CLI on Desktop
2. MacOS: General use will be developers using Terraform CLI on Desktop
3. Linux: General use will be automated pipelines like Azure DevOps (Ubuntu Agents)
### What are we doing here?
- As we are going to check-in our Dependency Lock file `.terraform.lock.hcl` to git to lock our provider versions we are ensuring we are generating that file for all platforms so that we don't face any issues when we run our configuration in different OS.
- Using multiple platform support providers lock command below, it creates the `.terraform.lock.hcl` which supports in all 3 environments.
- When we run the same Terraform config files in different OS (Linux) with file `.terraform.lock.hcl`, system will not fail and download that respective provider plugins.
```t
# Backup existing ".terraform.lock.hcl"  file
cp .terraform.lock.hcl .terraform.lock.hcl_macosonly

# Terraform Providers lock for multiple platforms
terraform providers lock -platform=windows_amd64 -platform=darwin_amd64 -platform=linux_amd64

# Diff Dependency lock files
diff .terraform.lock.hcl_macosonly .terraform.lock.hcl
```

## Step-06: Command: terraform providers mirror
- The `terraform providers mirror` command downloads the providers required for the current configuration and copies them into a directory in the local filesystem.
```t
# Change Directory
cd terraform-manifests/

# Create a Mirror Directory (Assuming we are in terraform-manifests folder)
mkdir ../mirror1

# Terraform Providers Mirror
terraform providers mirror ../mirror1

# Verify
ls -lrt ../mirror1/
ls -lrt ../mirror1/registry.terraform.io/hashicorp/
```

## Step-07: Command: terraform providers mirror for multiple platforms
```t
# Change Directory
cd terraform-manifests/

# Create a Mirror Directory (Assuming we are in terraform-manifests folder)
mkdir ../mirror2-multiplatforms

# Terraform Providers Mirror
terraform providers mirror -platform=windows_amd64 -platform=darwin_amd64 -platform=linux_amd64 ../mirror2-multiplatforms/

# Verify
ls -lrt ../mirror2-multiplatforms/
ls -lrt ../mirror2-multiplatforms/registry.terraform.io/hashicorp/
ls -lrt ../mirror2-multiplatforms/registry.terraform.io/hashicorp/azurerm

# Clean-Up
rm -rf ../mirror1
rm -rf ../mirror2-multiplatforms
```

## Step-08: Command: terraform providers schema
- The `terraform providers schema` command is used to **print detailed schemas** for the providers used in the current configuration.
```t
# Change Directory
cd terraform-manifests/

# Terraform Initialize (Ensure terraform working directory is initialized before schema command)
terraform init

# Terraform Providers Schema
terraform providers schema -json

# Terraform Providers Schema (Format JSON in readable format)
terraform providers schema -json | jq

# Terraform Providers Schema (Format JSON in readable format and store in a file)
terraform providers schema -json | jq > all-providers-schema.json
```

## Step-09: Review the all-providers-schema.json in VS Code
- Review the `all-providers-schema.json` file in VS Code
- Review each provider plugin entire schema on a high level. 

## Step-10: Clean-Up
```t
# Delete .terraform and .terraform.lock.hcl files
rm -rf .terraform*

# Leave this file as is
Will leave this file "all-providers-schema.json" in working directory for reference as is.
```