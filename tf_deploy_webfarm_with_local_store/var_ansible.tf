# ssh stuff
variable "ssh_credentials" {
  description = "ssh key files"
  type        = map(any)
  default = {
    "pub_key"  = "./files/keys/ec2-user.pub"
    "priv_key" = "./files/keys/ec2-user"
  }
}

# ansible
variable "ansible" {
  description = "ansible attributes"
  type        = map(any)
  default = {
    "ansible_inv_template" = "./files/templates/ansible_inventory.template"
    "ansible_inv"          = "../ansible/inventories/inventory"
  }
}

