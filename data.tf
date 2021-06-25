data "azurerm_image" {
    name                = var.image_name
    resource_group_name = var.resource_group
}