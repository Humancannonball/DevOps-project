variable "route_table" {
  type        = any
  description = "Configuration map for the route table."
}

variable "location" {
  type        = string
  description = "Location of the resource."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}