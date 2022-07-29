resource "azurerm_network_interface" "poc" {
  name                = join("_", [var.namespace, "nic", count.index])
  location            = var.location
  resource_group_name = var.rg_name
  count               = var.vm_count

  ip_configuration {
    name                          = join("_", [var.namespace, "pub_nic_cfg"])
    subnet_id                     = azurerm_subnet.poc.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    env = var.namespace
  }

  depends_on = [azurerm_resource_group.poc]
}

resource "azurerm_network_interface_security_group_association" "poc" {
  network_interface_id      = element(azurerm_network_interface.poc[*].id, count.index)
  network_security_group_id = azurerm_network_security_group.poc.id
  count                     = var.vm_count
}

resource "azurerm_linux_virtual_machine" "poc" {
  name                = join("-", [var.namespace, count.index, element(var.av_zones, count.index)])
  availability_set_id = null

  resource_group_name             = azurerm_resource_group.poc.name
  location                        = azurerm_resource_group.poc.location
  size                            = "Standard_F2"
  admin_username                  = var.vm_admin_username
  disable_password_authentication = true
  network_interface_ids           = [element(azurerm_network_interface.poc[*].id, count.index)]
  computer_name                   = join("-", [var.namespace, count.index, element(var.av_zones, count.index)])
  count                           = var.vm_count
  zone = element(var.av_zones, (count.index))

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

resource "azurerm_managed_disk" "poc" {
  name                = join("-", ["volume",count.index, element(var.av_zones, count.index)])
  count                = var.vm_count
  location             = var.location
  resource_group_name  = var.rg_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
  zones = [element(var.av_zones,count.index)]
  depends_on = [azurerm_resource_group.poc]
}

resource "azurerm_virtual_machine_data_disk_attachment" "poc" {
  managed_disk_id    = element(azurerm_managed_disk.poc[*].id, count.index)
  virtual_machine_id = element(azurerm_linux_virtual_machine.poc[*].id, count.index)
  count              = var.vm_count
  lun                = "10"
  caching            = "ReadWrite"
}
