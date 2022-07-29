data "azurerm_network_ddos_protection_plan" "poc" {
  name                = var.ddos_protection_plan
  resource_group_name  = var.network_rg_name
}


