resource "azurerm_public_ip" "poc_lb_ip" {
  name                = join("_", [var.namespace, "pub_ip_lb"])
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    env = var.namespace
  }

  depends_on = [azurerm_resource_group.poc]
}

resource "azurerm_lb" "poc" {
  name                = join("_", [var.namespace, "load_balancer"])
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = join("_", [var.namespace, "pub_ip_lb"])
    public_ip_address_id = azurerm_public_ip.poc_lb_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "poc" {
  loadbalancer_id = azurerm_lb.poc.id
  name            = join("_", [var.namespace, "backend_address_pool"])
}

resource "azurerm_lb_probe" "lb_probe_http" {
  resource_group_name = var.rg_name
  loadbalancer_id     = azurerm_lb.poc.id
  name                = join("_", [var.namespace, "lb_probe_http"])
  port                = var.http_backend_port
  protocol            = "Http"
  request_path        = "/status"
}

resource "azurerm_lb_rule" "lb_rule_http" {
  resource_group_name            = var.rg_name
  loadbalancer_id                = azurerm_lb.poc.id
  name                           = join("_", [var.namespace, "lb_rule_http"])
  protocol                       = "Tcp"
  backend_port                   = var.http_backend_port
  frontend_port                  = var.http_lb_port
  frontend_ip_configuration_name = join("_", [var.namespace, "pub_ip_lb"])
  backend_address_pool_id        = azurerm_lb_backend_address_pool.poc.id
  probe_id                       = azurerm_lb_probe.lb_probe_http.id
}

resource "azurerm_network_interface_backend_address_pool_association" "poc" {
  network_interface_id    = element(azurerm_network_interface.poc[*].id, count.index)
  count                   = var.vm_count
  ip_configuration_name   = join("_", [var.namespace, "pub_nic_cfg"])
  backend_address_pool_id = azurerm_lb_backend_address_pool.poc.id
}
