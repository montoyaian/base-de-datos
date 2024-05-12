terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = "true"
  features {

  }
}




locals {
  resource_group = "app-grp-db"
  location       = "East US"
}

resource "azurerm_resource_group" "app_grp" {
  name     = local.resource_group
  location = local.location
}

resource "azurerm_sql_firewall_rule" "allow_all" {
  name                = "AllowAll"
  resource_group_name = azurerm_resource_group.app_grp.name
  server_name         = azurerm_sql_server.app_server_montoya.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}

resource "azurerm_sql_server" "app_server_montoya" {
  name                         = "appservermontoya"
  resource_group_name          = azurerm_resource_group.app_grp.name
  location                     = "East US"
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "Azure@123"
}

resource "azurerm_sql_database" "app_db" {
  name                = "appdb"
  resource_group_name = azurerm_resource_group.app_grp.name
  location            = "East US"
  server_name         = azurerm_sql_server.app_server_montoya.name
  depends_on          = [azurerm_sql_server.app_server_montoya]
}



resource "null_resource" "run_ansible" {
  depends_on = [azurerm_sql_database.app_db]

  provisioner "local-exec" {
    command = "sleep 20 && ansible-playbook ansi.yaml"
  }
}

