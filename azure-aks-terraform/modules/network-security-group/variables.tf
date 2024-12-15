variable "network_security_group" {
  type        = any
  description = "Configuration map for the network security group."
}

variable "location" {
  type        = string
  description = "Location of the resource."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}