---
title: Terraform State Commands
description: Master Terraform State Commands
---

## Step-00: Introduction
- Terraform Commands
1. terraform show
2. terraform state
3. terraform force-unlock   
4. terraform taint
5. terraform untaint
6. terraform apply -target command  


## Step-01: Review Terraform Configs
1. c1-versions.tf
2. c2-variables.tf
3. c3-local-values.tf
4. c4-resource-group.tf
5. c5-virtual-network.tf
6. c6-datasouce-subscription.tf

## Step-02: Update the Terraform Backend Key
- Update `Terraform Backend Key`
- **c1-versions.tf**
```t
# Terraform State Storage to Azure Storage Container
  backend "azurerm" {
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformstate201"
    container_name        = "tfstatefiles"
    key                   = "state-commands-demo1.tfstate"
  }  
```

## Step-03: Terraform Show Command to review Terraform plan files
- The `terraform show` command is used to provide human-readable output from a state or plan file. 
- This can be used to inspect a plan to ensure that the planned operations are expected, or to inspect the current state as
- Terraform plan output files are binary files. We can read them using `terraform show` command
```t
# Initialize Terraform
terraform init

# Terraform Validate
terraform validate

# Create Plan 
terraform plan
terraform plan -out=v1plan.out

# Read the plan 
terraform show v1plan.out
terraform show  # Nothing as terraform.tfstate file not created yet

# Read the plan in json format (Unformatted / Not Readable)
terraform show -json v1plan.out 

# Install jq (for mac and fine tuned json output)
brew install jq
terraform show -json v1plan.out | jq
```

## Step-04: Terraform Show command to Read State files
- By default, in the working directory if we have `terraform.tfstate` file, when we provide the command `terraform show` it will read the state file automatically and display output.  
```t
# Terraform Show
terraform show
Observation: 
1. Ideally for AWS provider we get the message as "It should say "No State" because we will still didnt create any resources yet and no state file in current working directory"
2. For Azure Provider, empty response is coming. 

# Create Resources
#terraform apply -auto-approve
terraform apply v1plan.out

# Terraform Show 
terraform show
Observation: It should display the state file
```

## Step-05: Terraform State Command
### Step-05-01: Terraform State List and Show commands
- These two commands comes under **Terraform Inspecting State**
- **terraform state list:**  This command is used to list resources within a Terraform state.
- **terraform  state show:** This command is used to show the attributes of a single resource in the Terraform state.
```t
# List Resources from Terraform State
terraform state list

# Show the attributes of a single resource from Terraform State
terraform state show data.azurerm_resource_group.rgds
terraform state show data.azurerm_subscription.current
terraform state show azurerm_virtual_network.myvnet
```
### Step-05-02: Terraform State mv command
- This commands comes under **Terraform Moving Resources**
- This command will move an item matched by the address given to the
 destination address. 
- This command can also move to a destination address
 in a completely different state file
- Very dangerous command
- Very advanced usage command
- Results will be unpredictable if concept is not clear about terraform state files mainly  desired state and current state.  
- Try this in production environments, only  when everything worked well in lower environments. 
```t
# Terraform List Resources
terraform state list

# Terraform State Move Resources to different name
terraform state mv -dry-run azurerm_virtual_network.myvnet azurerm_virtual_network.myvnet-new
terraform state mv azurerm_virtual_network.myvnet azurerm_virtual_network.myvnet-new
terraform state list
ls -lrta # To verify state file backup


Observation: 
1) It renamed the name of "myvnet" in state file to "myvnet-new". 
2) Run terraform plan and observe what happens in next run of terraform plan and apply
-----------------------------
# WRONG APPROACH 
-----------------------------
# WRONG APPROACH OF MOVING TO TERRAFORM PLAN AND APPLY AFTER ABOVE CHANGE terraform state mv CHANGE
# WE NEED TO UPDATE EQUIVALENT RESOURCE in terraform manifests FIRST to match the same new name. 

# Terraform Plan
terraform plan
Observation: It will show "Plan: 1 to add, 0 to change, 1 to destroy."
1 to add: New VNET will be added
1 to destroy: Old VNET will be destroyed

 # azurerm_virtual_network.myvnet will be created
  + resource "azurerm_virtual_network" "myvnet" {

 # azurerm_virtual_network.myvnet-new will be destroyed
  - resource "azurerm_virtual_network" "myvnet-new" {


DON'T DO TERRAFORM APPLY because it shows make changes. Nothing changed other than state file local naming of a resource. Ideally nothing on current state (real cloud environment should not change due to this)
-----------------------------

Now run terraform plan and you should see no changes to Infra

# Terraform Plan
terraform plan
Observation: 
1) Message-1: No changes. Infrastructure is up-to-date
2) Message-2: This means that Terraform did not detect any differences between your TF configuration and real physical resources that exist. As a result, no actions need to be performed.
# Sample Message: 
Your configuration already matches the changes detected above. If you'd like to update the
Terraform state to match, create and apply a refresh-only plan:
  terraform apply -refresh-only

# Terraform Apply (refresh-only)
terraform apply -refresh-only
```
### Step-05-03: Terraform State rm command
- This commands comes under **Terraform Moving Resources Section**
- The `terraform state rm` command is used to remove items from the Terraform state. 
- This command can remove single resources, single instances of a resource, entire modules, and more.
```t
# Terraform List Resources
terraform state list

# Remove Resources from Terraform State
terraform state rm -dry-run azurerm_virtual_network.myvnet-new
terraform state rm azurerm_virtual_network.myvnet-new
Observation: 
1) Removes it from terraform.tfstate file

# Terraform Plan
terraform plan
Observation: It will tell you that resource is not in state file but same is present in your terraform manifests (c5-virtual-network.tf - DESIRED STATE). Do you want to re-create it?
This will re-create new Virtual Network excluding one created earlier and running

Make a  Choice
-------------
Choice-1: You want this resource to be running on cloud but should not be managed by terraform. Then remove its references in terraform manifests(DESIRED STATE). So that the one running in Azure cloud (current infra) this instance will be independent of terraform. 
Choice-2: You want a new resource to be created without deleting other one (non-terraform managed resource now in current state). Run terraform plan and apply
LIKE THIS WE NEED TO MAKE DECISIONS ON WHAT WOULD BE OUR OUTCOME OF REMOVING A RESOURCE FROM STATE.

PRIMARY REASON for this is command is that respective resource need to be removed from as terraform managed. 

# Run Terraform Plan (I made choice-2)
terraform plan # NO ERROR 
terraform apply -auto-approve # UNIQUE CONSTRAINT ERROR FOR VNET NAME

# Error Message
- YOU WILL get a unique resource name on Azure for Virtual Network under this resource group error when you run "terraform apply". 
- Change the Terraform Manifests Virtual Network name to different one and test
│ Error: A resource with the ID "/subscriptions/82808767-144c-4c66-a320-b30791668b0a/resourceGroups/hr-dev-myrg/providers/Microsoft.Network/virtualNetworks/hr-dev-myvnet" already exists - to be managed via Terraform this resource needs to be imported into the State. Please see the resource documentation for "azurerm_virtual_network" for more information.

# Update c5-virtual-network.tf
Before: name = local.vnet_name
After: name = "${local.vnet_name}-2"

# Update c7-datasource-virtual-network.tf
Before: name = local.vnet_name
After: name = "${local.vnet_name}-2"

# Run Terraform Plan Again
terraform plan
terraform plan -out=v2plan.out

# Run Terraform Apply
terraform apply v2plan.out

# Verify in Azure Portal
1. In Azure Portal, you should see two Virtual Networks in a Resource Group
- hr-dev-myvnet: Not managed by Terraform 
- hr-dev-myvnet-2: Managed by Terraform
```

### Step-05-04: Terraform State replace-provider command
- This commands comes under **Terraform Moving Resources Section**
- [Terraform State Replace Provider](https://www.terraform.io/docs/cli/commands/state/replace-provider.html)


### Step-05-05: Terraform State pull / push command
- This command comes under **Terraform Disaster Recovery Concept**
- **terraform state pull:** 
1. The `terraform state pull` command is used to manually download and output the state from remote state.
2. This command also works with local state.
3. This command will download the state from its current location and output the raw format to stdout.

- **terraform state push:** 
1. The `terraform state push` command is used to manually upload a local state file to remote state. 

```t
# Verify if any local state files
ls -lrta terraform.tfstate 

# Terraform state pull
terraform state pull # CLI will output the terraform state

# Create new state file locally
vi terraform.tfstate
COPY ABOVE "terraform state pull" output to this file

# Make a note of Current Remote State file last updated and Version ID (From Azure Storage Container )
LAST MODIFIED	6/11/2021, 12:50:22 PM
CREATION TIME	6/11/2021, 12:50:21 PM
VERSION ID	2021-06-11T07:20:22.2334683Z

# Terraform State Push
terraform state push terraform.tfstate

# Verify new State file copied in Azure Storage Container
LAST MODIFIED	6/11/2021, 12:57:23 PM
CREATION TIME	6/11/2021, 12:50:21 PM
VERSION ID	2021-06-11T07:27:23.0504198Z
```


## Step-06: Terraform force-unlock command
- This command comes under **Terraform Disaster Recovery Concept**
- Manually unlock the state for the defined configuration.
- This will not modify your infrastructure. 
- This command removes the lock on the state for the current configuration. 
- The behavior of this lock is dependent on the backend (if supports) being used. 
- **Important Note:** Local state files cannot be unlocked by another process.
```t
# Manually Unlock the State
terraform force-unlock LOCK_ID
```

## Step-07: Terraform taint & untaint commands
-  These commands comes under **Terraform Forcing Re-creation of Resources**
- When a resource declaration is modified, Terraform usually attempts to update the existing resource in place (although some changes can require destruction and re-creation, usually due to upstream API limitations).
- **Example:** A virtual machine that configures itself with cloud-init on startup might no longer meet your needs if the cloud-init configuration changes.
- **terraform taint:** The `terraform taint` command manually marks a Terraform-managed resource as tainted, forcing it to be destroyed and recreated on the next apply.
- **terraform untaint:** 
  - The terraform untaint command manually unmarks a Terraform-managed resource as tainted, restoring it as the primary instance in the state. 
  - This reverses either a manual terraform taint or the result of provisioners failing on a resource.
  - This command will not modify infrastructure, but does modify the state file in order to unmark a resource as tainted.
```t
# List Resources from state
terraform state list

# Taint a Resource
terraform taint <RESOURCE_NAME_IN_TERRAFORM_LOCALLY>
terraform taint azurerm_virtual_network.myvnet-new

# Terraform Plan
terraform plan
Observation: 
Message: "-/+ destroy and then create replacement"
Plan: 1 to add, 0 to change, 1 to destroy.

# Untaint a Resource
terraform untaint <RESOURCE_NAME_IN_TERRAFORM_LOCALLY>
terraform untaint azurerm_virtual_network.myvnet-new

# Terraform Plan
terraform plan
Observation: 
Message: "No changes. Your infrastructure matches the configuration."
```


## Step-08: Terraform Resource Targeting - Plan, Apply (-target) Option
- The `-target` option can be used to focus Terraform's attention on only a subset of resources. 
- [Terraform Resource Targeting](https://www.terraform.io/docs/cli/commands/plan.html#resource-targeting)
- This targeting capability is provided for exceptional circumstances, such as recovering from mistakes or working around Terraform limitations.
-  It is not recommended to use `-target` for routine operations, since this can lead to undetected configuration drift and confusion about how the true state of resources relates to configuration.
- Instead of using `-target` as a means to operate on isolated portions of very large configurations, prefer instead to break large configurations into several smaller configurations that can each be independently applied.
```t
# Lets make one change
Change-1: c5-virtual-network.tf: Add second value to address space 
  address_space       = ["10.0.0.0/16", "10.1.0.0/16"] 

Change-2: c5-virtual-network.tf: Add new Virtual Network Resource
# Another VNET - New Resource - Enable the below at step-08
resource "azurerm_virtual_network" "myvent9" {
  name = "myvnet9"
  address_space = [ "10.2.0.0/16" ]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name  
}


# List Resources from state
terraform state list

# Terraform plan
terraform plan
Observation:
1. Message: Plan: 1 to add, 1 to change, 0 to destroy.
2. 1 new VNET will be created
3. 1 change to existing VNET

# Terraform Plan with -target
terraform plan -target=azurerm_virtual_network.myvnet-new
Observation:
1) Message: "Plan: 0 to add, 1 to change, 0 to destroy"
2) It is updating Change-1 because we are targeting that resource "aws_instance.my-ec2-vm-new"
3) It is not touching the new resource which we are creating now "azurerm_virtual_network.myvent9". It will be in terraform configuration but not getting provisioned when we are using -target

# Terraform Apply
terraform apply -target=azurerm_virtual_network.myvnet-new
```

## Step-09: Terraform Destroy & Clean-Up
```t
# Destory Resources
terraform destroy -auto-approve

# Clean-Up Files
rm -rf .terraform*
rm -rf terraform.tfstate*
rm -rf v1plan.out
rm -rf v2plan.out
```

## Step-10: Put all Terraform Configs back for students at demo level
```t
# Kalyan - Not to forgot to change these things after Recording for students seamless demo
Change-1: c5-virtual-network.tf (Change back to base demo state)
# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {     # Comment during step-05-02
#resource "azurerm_virtual_network" "myvnet-new" {  # Uncomment during step-05-02
  name                = local.vnet_name # Comment during step-05-03
  #name                = "${local.vnet_name}-2" # Uncomment during step-05-03
  address_space       = local.vnet_address_space      # Comment at Step-08 
  #address_space       = ["10.0.0.0/16", "10.1.0.0/16"] # Uncomment at Step-08
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags = local.common_tags 
}

# Another VNET - New Resource - Uncomment the below at step-08
/*
resource "azurerm_virtual_network" "myvent9" {
  name = "myvnet9"
  address_space = [ "10.2.0.0/16" ]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name  
}
*/  
```

## References
- [Terraform State Command](https://www.terraform.io/docs/cli/commands/state/index.html)
- [Terraform Inspect State](https://www.terraform.io/docs/cli/state/inspect.html)
- [Terraform Moving Resources](https://www.terraform.io/docs/cli/state/move.html)
- [Terraform Disaster Recovery](https://www.terraform.io/docs/cli/state/recover.html)
- [Terraform Taint](https://www.terraform.io/docs/cli/state/taint.html)
- [Terraform State](https://www.terraform.io/docs/language/state/index.html)
- [Manipulating Terraform State](https://www.terraform.io/docs/cli/state/index.html)
- [Additional Reference](https://www.hashicorp.com/blog/detecting-and-managing-drift-with-terraform)

