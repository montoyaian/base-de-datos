

resource "null_resource" "run_ansible" {
  depends_on = [azurerm_sql_database.app_db]

  provisioner "local-exec" {
    command = "sleep 20 && ansible-playbook ansi.yaml"
  }
}

