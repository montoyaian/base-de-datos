

resource "null_resource" "run_ansible" {
  provisioner "local-exec" {
    command = "sleep 20 && ansible-playbook ansi.yaml"
  }
}

