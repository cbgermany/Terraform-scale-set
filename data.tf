# Obtain the Packer prepared base image
data "azurerm_image" "image" {
    name                = var.image_name
    resource_group_name = var.image_resource_group
}

# Define the cloudinit config
data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/templates/cloudinit.conf", 
        {
          url         = var.url,
          admin_url   = var.admin_url,
          endpoint    = var.endpoint,
          ghost_admin = var.ghost_admin_user
          username    = var.db_svr_admin_user,
          password    = var.db_svr_admin_password,
          database    = var.database
        })
  }
}
