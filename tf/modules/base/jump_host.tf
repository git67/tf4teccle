resource "azurerm_public_ip" "jumphost" {
  name                = join("_", [var.namespace, "pub_ip", "jumphost"])
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    env = var.namespace
  }

  depends_on = [azurerm_resource_group.poc]
}


resource "azurerm_network_interface" "jumphost" {
  name                = join("_", [var.namespace, "pub_nic", "jumphost"])
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = join("_", [var.namespace, "pub_nic_cfg"])
    subnet_id                     = azurerm_subnet.jumphost.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jumphost.id
  }

  tags = {
    env = var.namespace
  }

  depends_on = [azurerm_resource_group.poc]
}

resource "azurerm_network_interface_security_group_association" "jumphost" {
  network_interface_id      = azurerm_network_interface.jumphost.id
  network_security_group_id = azurerm_network_security_group.jumphost.id
}
resource "azurerm_linux_virtual_machine" "jumphost" {
  name                            = join("-", [var.namespace, "jumphost"])
  resource_group_name             = azurerm_resource_group.poc.name
  location                        = azurerm_resource_group.poc.location
  size                            = "Standard_F2"
  admin_username                  = var.vm_admin_username
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.jumphost.id]
  computer_name                   = join("-", [var.namespace, "jumphost"])

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = data.azurerm_ssh_public_key.ssh_pubkey.public_key
  }


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "8_4"
    version   = "latest"
  }
  tags = {
    env = var.namespace
  }

  depends_on = [azurerm_resource_group.poc]
}
