variable "network_security_group" {
  type = object({
    Name = string
    Rules = optional(list(object({
      Name                       = string
      Priority                   = number
      Direction                  = string
      Access                     = string
      Protocol                   = string
      SourcePortRange            = string
      DestinationPortRange       = string
      SourceAddressPrefix        = string
      DestinationAddressPrefix   = string
    })), [])
  })
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