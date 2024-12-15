resource "azurerm_route_table" "rt" {
  name                = var.route_table.Name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "route" {
    for_each = var.route_table.Routes
    content {
      name                   = route.value.Name
      address_prefix         = route.value.AddressPrefix
      next_hop_type          = route.value.NextHopType
    }
  }
}