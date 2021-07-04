# Expose the fully qualified domain name
output "vmss_public_ip" {
    value = azurerm_public_ip.vmss.fqdn
}

output "ghost_config" {
    value = data.template_cloudinit_config.config
    sensitive = true
}