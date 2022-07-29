output "jumphost_ip" {
  value = module.poc.jumphost_ip
}

resource "local_file" "inventory" {
  content = templatefile(var.ansible["ansible_inv_template"],
    {
      group_name   = "poc"
      internal_ips = module.poc.vm_internal_ips
      jumphost_ip  = module.poc.jumphost_ip
      ssh_user     = module.poc.vm_admin_username
      ssh_key_file = var.ansible["ansible_ssh_key_path"]
    }
  )
  filename = var.ansible["ansible_inv"]
}

resource "local_file" "ssh_key" {
  content = templatefile(var.ansible["ansible_ssh_key_template"],
    {
      group_name = "poc"
      ssh_key    = module.poc.ssh_key
    }
  )
  filename        = var.ansible["ansible_ssh_key_path"]
  file_permission = "0400"
}

output "load_balancer_ip" {
  description = "Load balancer ip"
  value       = module.poc.load_balancer_ip
}
