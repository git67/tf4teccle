resource "azurerm_virtual_network" "poc" {
  name                = join("_", [var.namespace, "vnet"])
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = var.rg_name

  ddos_protection_plan {
    id     = data.azurerm_network_ddos_protection_plan.poc.id
    enable = true
  }

  depends_on = [azurerm_resource_group.poc]

  tags = {
    env = var.namespace
  }
}

resource "azurerm_subnet" "poc" {
  name                 = join("_", [var.namespace, "subnet"])
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.poc.name
  address_prefixes     = var.subnet_address_prefixes

  depends_on = [azurerm_virtual_network.poc]
}

resource "azurerm_subnet" "jumphost" {
  name                 = join("_", [var.namespace, "jumphost_subnet"])
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.poc.name
  address_prefixes     = var.jumphost_net_prefixes

  depends_on = [azurerm_virtual_network.poc]
}
