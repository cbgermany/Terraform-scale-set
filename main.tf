#Generate a random string for the domain name
resource "random_string" "fqdn" {
  length  = 6
  special = false
  upper   = false
  number  = false
}

# Create Standard Public IP for the load balancer across Availability Zones
resource "azurerm_public_ip" "vmss" {
  name                 = format("%s-%s", var.name, "publicIp")
  location             = var.location
  resource_group_name  = var.resource_group
  allocation_method    = "Static"
  domain_name_label    = random_string.fqdn.result
  sku                  = "Standard"

  tags = merge(
    var.common_tags,
    tomap(
      {"Component" = "Scale Set"}
    )
  )
}

# Create the Public Load Balancer that will be infront of the VM Scale Set
resource "azurerm_lb" "vmss" {
  name                = format("%s-%s", var.name, "lb")
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = format("%s-%s", var.name, "PublicIP")
    public_ip_address_id = azurerm_public_ip.vmss.id
  }

  tags = merge(
    var.common_tags,
    tomap(
      {"Component" = "Scale Set"}
    )
  )  
}

# Create the load balancer backend address pool
resource "azurerm_lb_backend_address_pool" "vmss" {
  name             = format("%s-%s", var.name, "backendpool")
  loadbalancer_id  = azurerm_lb.vmss.id
}

# Create the load balancer probe
resource "azurerm_lb_probe" "vmss" {
  name                = format("%s-%s", var.name, "lb-probe")
  resource_group_name = var.resource_group
  loadbalancer_id     = azurerm_lb.vmss.id
  port                = var.application_port
}

# Create the load balancer Nat rule
resource "azurerm_lb_rule" "vmss" {
  resource_group_name            = var.resource_group
  loadbalancer_id                = azurerm_lb.vmss.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = var.application_port
  backend_port                   = var.application_port
  backend_address_pool_id        = azurerm_lb_backend_address_pool.vmss.id
  frontend_ip_configuration_name = format("%s-%s", var.name, "PublicIP")
  probe_id                       = azurerm_lb_probe.vmss.id
}

# Create the Virtual Machine Scale Set
resource "azurerm_linux_virtual_machine_scale_set" "vmss" {

  # Prevent Terraform clashing with Auto scaling and Azre DevOps
  lifecycle {
    ignore_changes = [
      instances,
    ]
  }

  name                = format("%s-%s", var.name, "vmss")
  resource_group_name = var.resource_group
  location            = var.location

  sku       = var.sku  
  instances = var.instances

  admin_username = var.admin_user
  admin_password = var.admin_password

  disable_password_authentication = false

  custom_data = base64encode(data.template_cloudinit_config.config.rendered)

  #admin_ssh_key {
  #  username   = var.admin_user
  #  public_key = var.public_key
  #}

  source_image_id = data.azurerm_image.image.id

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "vmss_primary"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = var.subnet_id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.vmss.id]
    }
  }

  tags = merge(
    var.common_tags,
    tomap(
      {"Component" = "Database"}
    )
  )
}
