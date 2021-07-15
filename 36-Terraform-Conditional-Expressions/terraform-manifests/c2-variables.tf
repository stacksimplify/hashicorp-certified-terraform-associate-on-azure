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
  #default = "qa"
}
# 3. Resource Group Name
variable "resoure_group_name" {
  description = "Resource Group Name"
  type = string
  default = "myrg"
}
# 4. Resource Group Location
variable "resoure_group_location" {
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

# 6. Virtual Network Address - Dev
variable "vnet_address_space_dev" {
  description = "Virtual Network Address Space for Dev Environment"
  type = list(string)
  default = [ "10.0.0.0/16" ]
}

# 7. Virtual Network Address - 
variable "vnet_address_space_all" {
  description = "Virtual Network Address Space for All Environments except dev"
  type = list(string)
  default = [ "10.1.0.0/16", "10.2.0.0/16", "10.3.0.0/16"  ]
}
