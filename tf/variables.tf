# az creds
variable "az_creds" {
  description = "az credential"
  type        = map(any)
  default = {
    "subscription_id" = "<substcription id>"
    "tenant_id"       = "<tenant id>"
  }
}

# ansible
variable "ansible" {
  description = "ansible attributes"
  type        = map(any)
  default = {
    "ansible_inv_template"     = "./files/templates/ansible_inventory.template"
    "ansible_inv"              = "../ansible/inventories/inventory"
    "ansible_ssh_key_template" = "./files/templates/id_rsa.template"
    "ansible_ssh_key_path"     = "../ansible/id_rsa"
  }
}

