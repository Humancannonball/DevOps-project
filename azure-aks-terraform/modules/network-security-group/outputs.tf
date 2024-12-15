output "nsg_resource_id" {
  value       = azurerm_network_security_group.nsg.id
  description = "The ID of the network security group."
}