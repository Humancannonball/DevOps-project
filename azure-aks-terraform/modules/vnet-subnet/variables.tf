variable "subnet" {
  type        = any
  description = "Configuration map for the subnet."
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the associated virtual network."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "location" {
  type        = string
  description = "Location of the resources."
}

variable "nsg_id" {
  type        = string
  description = "ID of the Network Security Group to associate."
}

variable "rt_id" {
  type        = string
  description = "ID of the Route Table to associate."
}