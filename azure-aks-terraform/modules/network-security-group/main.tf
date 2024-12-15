resource "azurerm_network_security_group" "nsg" {
  name                = var.network_security_group.Name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = var.network_security_group.Rules
    content {
      name                       = security_rule.value.Name
      priority                   = security_rule.value.Priority
      direction                  = security_rule.value.Direction
      access                     = security_rule.value.Access
      protocol                   = security_rule.value.Protocol
      source_port_range          = security_rule.value.SourcePortRange
      destination_port_range     = security_rule.value.DestinationPortRange
      source_address_prefix      = security_rule.value.SourceAddressPrefix
      destination_address_prefix = security_rule.value.DestinationAddressPrefix
    }
  }
}