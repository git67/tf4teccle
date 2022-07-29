resource "azurerm_network_security_group" "jumphost" {
  name                = join("_", [var.namespace, "secgrp-jumphost"])
  location            = var.location
  resource_group_name = var.rg_name

  depends_on = [azurerm_resource_group.poc]

  tags = {
    env = var.namespace
  }
}
resource "azurerm_network_security_group" "poc" {
  name                = join("_", [var.namespace, "secgrp"])
  location            = var.location
  resource_group_name = var.rg_name

  depends_on = [azurerm_resource_group.poc]

  tags = {
    env = var.namespace
  }
}

resource "azurerm_network_security_rule" "http" {
  name                        = join("_", [var.namespace, "rule_http"])
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = var.http_backend_port
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.poc.name

  depends_on = [azurerm_resource_group.poc]
}

resource "azurerm_network_security_rule" "https" {
  name                        = join("_", [var.namespace, "rule_https"])
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = var.https_backend_port
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.poc.name

  depends_on = [azurerm_resource_group.poc]
}

resource "azurerm_network_security_rule" "jumphost" {
  name                        = join("_", [var.namespace, "rule_ssh_jumphost"])
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.jumphost.name

  depends_on = [azurerm_resource_group.poc]
}
