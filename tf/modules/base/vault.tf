data "azurerm_key_vault" "ssh_keyvault" {
  name                = var.ssh_vault_name
  resource_group_name = var.ssh_keys_rg
}

data "azurerm_key_vault_secret" "ssh_key" {
  name         = var.ssh_private_key_name
  key_vault_id = data.azurerm_key_vault.ssh_keyvault.id
}

data "azurerm_ssh_public_key" "ssh_pubkey" {
  name                = var.ssh_pubkey_name
  resource_group_name = var.ssh_keys_rg
}
