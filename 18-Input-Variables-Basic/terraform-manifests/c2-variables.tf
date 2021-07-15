# Input Variables

# 1. Business Unit Name
variable "business_unit" {
  description = "Business Unit Name"
  type = string 
  default = "hr"
}
# 2. Environment Name
variable "environment" {
  description = "Environment Name"
  type = string
  default = "dev"
}
# 3. Resource Group Name
variable "resource_group_name" {
  description = "Resource Group Name"
  type = string
  default = "myrg"
}
# 4. Resource Group Location
variable "resource_group_location" {
  description = "Resource Group Location"
  type = string
  default = "East US"
}
# 5. Virtual Network Name
variable "virtual_network_name" {
  description = "Virtual Network Name"
  type = string
  default = "myvnet"
}

# YOU CAN ADD LIKE THIS MANY MORE argument values from each resource
# 6. Subnet Name
# 7. Public IP Name
# 8. Network Interface Name
# 9. Virtual Machine Name
# 10. VM OS Disk Name
# 11. .....
# 12. ....

