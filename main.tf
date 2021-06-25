# Create Standard Public IP for Availability Zones
resource "azurerm_public_ip" "mvsspubblicip" {
  name                 = format("%s-%s", var.name,"publicIp")
  location             = var.location
  resource_group_name  = var.resource_group
  allocation_method    = "Dynamic"
  sku                  = "Standard"

  tags = merge(
    var.common_tags,
    tomap(
      {"Component" = "Database"}
    )
  )
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "mvssnsg" {
    name                = format("%s-%s", var.name, "vmnsg")
    location            = var.location
    resource_group_name = var.resource_group
    tags = {
        environment = "Terraform Demo"
    }
}

# Allow port 22
resource "azurerm_network_security_rule" "mvssngs-ssh" {
  name                        = format("%s-%s", var.name, "nsgsshrule")
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group
  network_security_group_name = azurerm_network_security_group.mvssnsg.name
}

# Allow port 443
resource "azurerm_network_security_rule" "mvssngs-https" {
  name                        = format("%s-%s", var.name, "nsghttpsrule")
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group
  network_security_group_name = azurerm_network_security_group.mvssnsg.name
}

resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = var.name
  resource_group_name = var.resource_group
  location            = var.location
  sku                 = var.sku
  instances           = 1
  admin_username      = var.unix_admin

  admin_ssh_key {
    username   = var.unix_admin
    public_key = var.public_key
  }

  source_image_reference {
    id = data.azurerm_image.id
  }

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
    }

 #   public_ip_address 
  }

  tags = merge(
    var.common_tags,
    tomap(
      {"Component" = "Database"}
    )
  )
}