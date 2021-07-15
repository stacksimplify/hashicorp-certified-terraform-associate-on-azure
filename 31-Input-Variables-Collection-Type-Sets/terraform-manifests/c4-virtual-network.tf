# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  for_each = var.environment
  name                = "${var.business_unit}-${each.key}-${var.virtual_network_name}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg[each.key].location
  resource_group_name = azurerm_resource_group.myrg[each.key].name
}

# Create Subnet
resource "azurerm_subnet" "mysubnet" {
  for_each = var.environment
  #name                 = "mysubnet-1"
  name = "${var.business_unit}-${each.key}-${var.virtual_network_name}-mysubnet"
  resource_group_name  = azurerm_resource_group.myrg[each.key].name
  virtual_network_name = azurerm_virtual_network.myvnet[each.key].name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create Public IP Address
resource "azurerm_public_ip" "mypublicip" {
  for_each = var.environment
  #name                = "mypublicip-1"
  name = "${var.business_unit}-${each.key}-mypublicip"  
  resource_group_name = azurerm_resource_group.myrg[each.key].name
  location            = azurerm_resource_group.myrg[each.key].location
  allocation_method   = "Static"
  #domain_name_label = "app1-vm-${random_string.myrandom[each.key].id}"
  domain_name_label = "app1-vm-${each.key}-${random_string.myrandom[each.key].id}"
  tags = {
    environment = each.key
  }
}

# Create Network Interface
resource "azurerm_network_interface" "myvmnic" {
  for_each = var.environment
  #name                = "vmnic"
  name = "${var.business_unit}-${each.key}-${var.virtual_network_name}-myvmnic"    
  location            = azurerm_resource_group.myrg[each.key].location
  resource_group_name = azurerm_resource_group.myrg[each.key].name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.mypublicip[each.key].id 
  }
}
