# Terraform-scale-set
Terraform module to create a linux scale-set in Azure

# Introduction
This module creates a public load balancer and an Azure VM Scale Set.  The Scale Set it limited to 1 as the Ghost application does not support sharding or clustering.

The VM is created as a scale set to offer self healing in the event of an outage to the underlying host or a failure with an availability zone.

# Usage
```hcl
module "ghost_scale_set" {
  source = "../../modules/Terraform-scale-set"
  #source = "git::https://github.com/cbgermany/Terraform-scale-set.git?ref=v0.1"

  name            = "uniquename"
  location        = "UK South"
  resource_group  = "rg1"

  domain_name_label    = random_string.fqdn.result

  image_name           = "Ghost_Ubuntu_20_04_lts_Image"
  image_resource_group = "GhostRG"

  sku = "Standard_D2s_v3"
  instances = 1

  ghost_admin_user     = "ghostadmin"
  ghost_admin_password = "A secret pasword"

  db_svr_admin_user     = "MySql server admin username"
  db_svr_admin_password = "MySql server admin password"

  subnet_id = "Subnet ID of the Frontent that will access the DB"

  common_tags = data.terraform_remote_state.common.outputs.tags

  # Parameters for Cloudinit to install Ghost
  url       = "URL of the Ghost blog"
  admin_url = "Admin URL can be empty string"
  endpoint  = "MySql enpoint in Azure"
  database  = "MySql database name"

  # For Let's Encrypt the email to use
  sslemail = "example@myemail.com"

  common_tags = data.terraform_remote_state.common.outputs.tags
}
```

# Parameters
| Name | Type | Mandatory | Description |
| ---- | ---- | ----------| ----------- |
| name | string | Yes | Name of the Azure Scale |
| domain_name_label | string | Yes | Unique name to assign to the Public IP and create a DNS entry |
| resource_group | string | Yes | Resource group to create the resources |
| location | string | Yes | Azure location e.g. "uksouth" |
| image_name | string | Yes | The name of the image to creat the Scale Set Instance |
| image_resource_group | string | Yes | The resource group where the image is located |
| sku | string | Yes | The size of the VM in the scale set |
| instances | number | No | defaults to 1 (should always be set to 1 for Ghost VMs) |
| ghost_admin_user | string | Yes | The unix user name for the scale set VM |
| ghost_admin_password | string | Yes | The unix user password to access the VM |
| db_svr_admin_user | string | Yes | The unix user name for the MySql database server |
| db_svr_admin_password | string | Yes | The unix user password for the MySql database serer |
| subnet_id | string | Yes | The Subnet ID where the VMs will be created |
| url | string | Yes | The https url for the Ghost Blog |
| admin_url | string | No | The https url for the Admin of the Ghost Blog |
| endpoint | string | Yes | The MySql server - server name |
| database | string | Yes | The name of the MySql database |
| sslemail | string | Yes | The email used by Let's Encrypt to generate the SSL certificates |
| common_tags | map | Yes | Map of tags common to all resources |

# Outputs
* **vmss_public_ip**: The Public IP address assigned to the load balancer

* **ghost_config**: The Cloud init config used to install ghost
