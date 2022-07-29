output "jumphost_ip" {
  description = "Public ip of jump host"
  value       = azurerm_linux_virtual_machine.jumphost.public_ip_address

}

output "load_balancer_ip" {
  description = "Load balancer ip"
  value       = azurerm_public_ip.poc_lb_ip.ip_address
}

output "vm_internal_ips" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = azurerm_linux_virtual_machine.poc[*].private_ip_address
}

output "vm_admin_username" {
  description = "admin user"
  value       = var.vm_admin_username
}

output "ssh_key" {
  description = "ssh private key"
  value       = data.azurerm_key_vault_secret.ssh_key.value
}
