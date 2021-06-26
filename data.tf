data "azurerm_image" "image" {
    name                = var.image_name
    resource_group_name = var.image_resource_group
}