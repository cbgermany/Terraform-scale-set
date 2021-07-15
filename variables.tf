# This defines the list of variables used by this module

variable "name" {
  description = "The name of the Virtual Machine Scale Set"
  type        = string
}

variable "domain_name_label" {
  description = "The domain name associated with the Public IP of the Load Balancer"
  type        = string
}

variable "resource_group" {
  description = "The resource group associated with the database"
  default     = "mysqlRG"
}

variable "location" {
  description = "The Region/Location where the Database should be created"
  default     = "UK South"
}

variable "image_name" {
  description = "The name of the VM image"
  type        = string
}

variable "image_resource_group" {
  description = "The resourece group containing the image"
  type        = string
}

variable "sku" {
  description = "The sku for the VM scale set, i.e. Standard_D2s_v3"
  type = string
}

variable "instances" {
  description = "The number of instances to be created in the scale set"
  type        = number
}

variable "ghost_admin_user" {
  description = "The username of the ghost admin user"
  type        = string
}

variable "ghost_admin_password" {
  description = "The password for the ghost admin user"
  type       = string
}

variable "db_svr_admin_user" {
  description = "The Unix Administration Account for the MySql server"
  type        = string
}

variable "db_svr_admin_password" {
  description = "The unix admin user password for the MySql server"
  type        = string 
}

variable "subnet_id" {
    description = "The subnet id where the VM IP address will be created"
}

variable "common_tags" {
  description = "A Map of common tags to assign to the network security group"
  type        = map(string)
}

variable "url" {
  description = "The url for the Ghost blog"
  type        = string
}

variable "admin_url" {
  description = "The admin url for the Ghost blog"
  type        = string
}

variable "endpoint" {
  description = "The MySQL database server endpoint"
}

variable "database" {
  description = "The name of the database"
  type        = string
}

variable "sslemail" {
  description = "The SSL email contact to be used for Let's Encrypt"
  type        = string
}