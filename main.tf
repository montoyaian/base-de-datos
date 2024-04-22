terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0"
    }
  }
}

provider "azurerm" {
    features {}
    subscription_id = "498b2d39-4e52-47b6-a5db-26e2295a6498"
    client_id       = "d75efb8f-6614-4576-8bab-21eb2ee01d16"
    client_secret   = "dLY8Q~YIhsj~yJt.5J4EGgPkm9rxmiOdkWGE6dql"
    tenant_id       = "d58477fd-f9c4-4eb6-a699-400fd4f0a312"
}


locals {
  resource_group = "app-grp"
  location       = "East US"
}

resource "azurerm_resource_group" "app_grp" {
  name     = local.resource_group
  location = local.location
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

