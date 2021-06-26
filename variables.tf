# This defines the list of variables used by this module

variable "name" {
  description = "The name of the Virtual Machine Scale Set"
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

variable "application_port" {
  description = "The port for the load balancer to probe"
  type        = string
}

variable "sku" {
  description = "The sku for the VM scale set, i.e. Standard_D2s_v3"
  type = string
}

variable "unix_admin" {
    description = "The Unix Administration Account"
    type        = string
}

variable "public_key" {
    description = "The public key that is used to access the VM"
}

variable "subnet_id" {
    description = "The subnet id where the VM IP address will be created"
}

variable "common_tags" {
  description = "A Map of common tags to assign to the network security group"
  type        = map(string)
}