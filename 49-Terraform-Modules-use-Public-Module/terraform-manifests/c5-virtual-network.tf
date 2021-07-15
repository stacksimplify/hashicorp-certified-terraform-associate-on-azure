/*
# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  name                = local.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags = local.common_tags
}

# Create Subnet
resource "azurerm_subnet" "mysubnet" {
  name                 = local.snet_name
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
*/
# Create Virtual Network and Subnets using Terraform Public Registry Module
module "vnet" {
  source  = "Azure/vnet/azurerm"
  version = "2.5.0" # No versions constraints for production grade implementation - always lock version in prod for modules
  vnet_name = local.vnet_name
  resource_group_name = azurerm_resource_group.myrg.name
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]
  subnet_service_endpoints = {
    subnet2 = ["Microsoft.Storage", "Microsoft.Sql"],
    subnet3 = ["Microsoft.AzureActiveDirectory"]
  }
  tags = {
    environment = "dev"
    costcenter  = "it"
  }
  depends_on = [azurerm_resource_group.myrg]   
}

# Create Public IP Address
resource "azurerm_public_ip" "mypublicip" {
  name                = local.pip_name
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label = "app1-${terraform.workspace}-${random_string.myrandom.id}"
  tags = local.common_tags
}

# Create Network Interface
resource "azurerm_network_interface" "myvmnic" {
  name                = local.nic_name
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    #subnet_id                    = azurerm_subnet.mysubnet.id       
    subnet_id                     = module.vnet.vnet_subnets[0]      
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.mypublicip.id 
  }
  tags = local.common_tags
}
