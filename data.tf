# Obtain the Packer prepared base image
data "azurerm_image" "image" {
    name                = var.image_name
    resource_group_name = var.image_resource_group
}

# Retrieve the file used for cloudinit
data "local_file" "cloudinit" {
    filename = "${path.module}/cloudinit.conf"
}
