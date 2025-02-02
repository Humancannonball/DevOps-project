resource "azurerm_resource_group" "rg" {
  for_each = { for key in local.config.resource_groups : key.Name => key }

  name     = each.value.Name
  location = local.config.location
  tags     = lookup(each.value, "Tags", null) != null ? each.value.Tags : {}
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = local.config.virtual_network.Name
  location            = local.config.location
  resource_group_name = azurerm_resource_group.rg[local.config.virtual_network.ResourceGroupName].name
  address_space       = local.config.virtual_network.AddressSpaces

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

module "network-security-group" {
  for_each = { for key in local.config.network_security_groups : key.Name => key }

  source = "./modules/network-security-group"

  network_security_group = each.value
  resource_group_name    = azurerm_resource_group.rg[each.value.ResourceGroupName].name
  location               = local.config.location
}

module "route-table" {
  for_each = { for key in local.config.route_tables : key.Name => key }

  source = "./modules/route-table"

  route_table         = each.value
  resource_group_name = azurerm_resource_group.rg[each.value.ResourceGroupName].name
  location            = local.config.location
}

module "vnet-subnet" {
  for_each = { for key in local.config.virtual_network.Subnets : key.Name => key }

  source = "./modules/vnet-subnet"

  subnet = each.value
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name = azurerm_virtual_network.vnet.resource_group_name
  location = local.config.location

  nsg_id = module.network-security-group[each.value.NetworkSecurityGroup].nsg_resource_id
  rt_id = module.route-table[each.value.RouteTable].rt_resource_id
}

resource "azurerm_user_assigned_identity" "k8s_identity" {
  name                = local.config.user_assigned_identity.Name
  resource_group_name = azurerm_resource_group.rg[local.config.user_assigned_identity.ResourceGroupName].name
  location            = local.config.location
}

resource "azurerm_role_assignment" "route_table_permission" {
  scope                = module.route-table["rt-aks"].rt_resource_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.k8s_identity.principal_id
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = local.config.azure_kubernetes_cluster.Name
  location            = local.config.azure_kubernetes_cluster.Location
  resource_group_name = azurerm_resource_group.rg[local.config.azure_kubernetes_cluster.ResourceGroupName].name
  dns_prefix          = local.config.azure_kubernetes_cluster.DnsPrefix

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.k8s_identity.id]
  }

  default_node_pool {
    name           = "agentpool"
    vm_size        = local.config.azure_kubernetes_cluster.NodeSize
    node_count     = local.config.azure_kubernetes_cluster.NodeCount
    vnet_subnet_id = module.vnet-subnet[local.config.azure_kubernetes_cluster.SubnetName].subnet_id
  }

  network_profile {
    network_plugin    = local.config.azure_kubernetes_cluster.NetworkProfile.NetworkPlugin
    load_balancer_sku = local.config.azure_kubernetes_cluster.NetworkProfile.LoadBalancerSku
    outbound_type     = local.config.azure_kubernetes_cluster.NetworkProfile.OutboundType
  }

  role_based_access_control {
    enabled = true
  }

  addon_profile {
    kube_dashboard {
      enabled = true
    }
  }
}

resource "azurerm_storage_account" "sa" {
  name                     = local.config.storage_account.Name
  resource_group_name      = azurerm_resource_group.rg[local.config.storage_account.ResourceGroupName].name
  location                 = local.config.location
  account_tier             = local.config.storage_account.AccountTier
  account_replication_type = local.config.storage_account.AccountReplicationType
  lifecycle {
    prevent_destroy = true
  }  
}
resource "azurerm_storage_container" "tfstate" {
  name                  = local.config.storage_container[0].Name
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = local.config.storage_container[0].ContainerAccessType
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_container_registry" "acr" {
  name                = local.config.container_registry.Name
  resource_group_name = azurerm_resource_group.rg[local.config.container_registry.ResourceGroupName].name
  location            = local.config.container_registry.Location
  sku                 = local.config.container_registry.Sku
  admin_enabled       = local.config.container_registry.AdminEnabled
}
