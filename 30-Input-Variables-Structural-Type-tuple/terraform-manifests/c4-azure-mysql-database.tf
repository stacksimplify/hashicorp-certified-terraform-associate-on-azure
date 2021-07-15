# Azure MySQL Database Server
resource "azurerm_mysql_server" "mysqlserver" {
  name                = "${var.business_unit}-${var.environment}-${var.db_name}" 
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  administrator_login          = var.db_username
  administrator_login_password = var.db_password

  #sku_name   = "B_Gen5_2" # Basic Tier
  sku_name = "GP_Gen5_2"   # General Purpose Tier
  /*
  expected sku_name to be one of [B_Gen4_1 B_Gen4_2 B_Gen5_1 B_Gen5_2 GP_Gen4_2 GP_Gen4_4 GP_Gen4_8 GP_Gen4_16 GP_Gen4_32 GP_Gen5_2 GP_Gen5_4 GP_Gen5_8 GP_Gen5_16 GP_Gen5_32 GP_Gen5_64 MO_Gen5_2 MO_Gen5_4 MO_Gen5_8 MO_Gen5_16 MO_Gen5_32], got 
  */
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

/*
  threat_detection_policy {
    enabled = true
    retention_days = 10
    email_account_admins = true
    email_addresses = [ "dkalyanreddy@gmail.com", "stacksimplify@gmail.com" ]
  }  
*/
/* #Structure Type: object()
  threat_detection_policy {
    enabled = var.tdpolicy.enabled
    retention_days = var.tdpolicy.retention_days
    email_account_admins = var.tdpolicy.email_account_admins
    email_addresses = var.tdpolicy.email_addresses    
  }
*/  
  threat_detection_policy {
    enabled = var.tdpolicy[0]
    retention_days = var.tdpolicy[1]
    email_account_admins = var.tdpolicy[2]
    email_addresses = var.tdpolicy[3]
  }  
}

# Create Database inside Azure MySQL Database Server
resource "azurerm_mysql_database" "webappdb1" {
  name                = "webappdb1"
  resource_group_name = azurerm_resource_group.myrg.name
  server_name         = azurerm_mysql_server.mysqlserver.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}
