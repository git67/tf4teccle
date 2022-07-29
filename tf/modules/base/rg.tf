resource "azurerm_resource_group" "poc" {
  name     = var.rg_name
  location = var.location

  tags = {
    env = var.namespace
  }
}

