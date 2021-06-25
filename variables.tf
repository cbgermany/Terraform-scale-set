# This defines the list of variables used by this module

variable "resource_group" {
  description = "The resource group associated with the database"
  default     = "mysqlRG"
}

variable "location" {
  description = "The Region/Location where the Database should be created"
  default     = "UK South"
}

variable "image_name" {
  description = "The name of the image used for the creation of the VM Scale Set"
  type        = string
}

variables "sku" {
    description = "The SKU or size of the VM that will run the scale set"
    type        = string
    default     = "D2s_v3"
}

variable "unix_admin" {
    description = "The Unix Administration Account"
    type        = string
}

variable "public_key" {
    description = "The public key that is used to access the VM"
}

variables "subnet_id" {
    description = "The subnet id where the VM IP address will be created"
}

variable "common_tags" {
  description = "A Map of common tags to assign to the network security group"
  type        = map(string)
}