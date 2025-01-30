resource "azurerm_resource_group" "rg" {
  for_each = { for key in local.config.ResourceGroups : key.Name => key }

  name     = each.value.Name
  location = local.config.Location
  tags     = lookup(each.value, "Tags", null) != null ? each.value.Tags : {}
}

resource "azurerm_virtual_network" "vnet" {
  name                = local.config.VirtualNetwork.Name
  location            = local.config.Location
  resource_group_name = azurerm_resource_group.rg[local.config.VirtualNetwork.ResourceGroupName].name
  address_space       = local.config.VirtualNetwork.AddressSpaces

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

module "network-security-group" {
  for_each = { for key in local.config.NetworkSecurityGroups : key.Name => key }

  source = "./modules/network-security-group"

  network_security_group = each.value
  resource_group_name    = azurerm_resource_group.rg[each.value.ResourceGroupName].name
  location               = local.config.Location
}

module "route-table" {
  for_each = { for key in local.config.RouteTables : key.Name => key }

  source = "./modules/route-table"

  route_table         = each.value
  resource_group_name = azurerm_resource_group.rg[each.value.ResourceGroupName].name
  location            = local.config.Location
}

module "vnet-subnet" {
  for_each = { for key in local.config.VirtualNetwork.Subnets : key.Name => key }

  source = "./modules/vnet-subnet"

  subnet = each.value
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name = azurerm_virtual_network.vnet.resource_group_name
  location = local.config.Location

  nsg_id = module.network-security-group[each.value.NetworkSecurityGroup].nsg_resource_id
  rt_id = module.route-table[each.value.RouteTable].rt_resource_id
}

resource "azurerm_user_assigned_identity" "k8s_identity" {
  name                = local.config.UserAssignedIdentity.Name
  resource_group_name = azurerm_resource_group.rg[local.config.UserAssignedIdentity.ResourceGroupName].name
  location            = local.config.Location
}

resource "azurerm_role_assignment" "route_table_permission" {
  scope                = module.route-table["rt-aks"].rt_resource_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.k8s_identity.principal_id
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = local.config.AzureKubernetesCluster.Name
  location            = local.config.AzureKubernetesCluster.Location
  resource_group_name = azurerm_resource_group.rg[local.config.AzureKubernetesCluster.ResourceGroupName].name
  dns_prefix          = local.config.AzureKubernetesCluster.DnsPrefix

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.k8s_identity.id]
  }

  default_node_pool {
    name           = "agentpool"
    vm_size        = local.config.AzureKubernetesCluster.NodeSize
    node_count     = local.config.AzureKubernetesCluster.NodeCount
    vnet_subnet_id = module.vnet-subnet[local.config.AzureKubernetesCluster.SubnetName].subnet_id
    os_disk_type   = "Ephemeral"
  }

  network_profile {
    network_plugin    = local.config.AzureKubernetesCluster.NetworkProfile.NetworkPlugin
    load_balancer_sku = local.config.AzureKubernetesCluster.NetworkProfile.LoadBalancerSku
    outbound_type     = local.config.AzureKubernetesCluster.NetworkProfile.OutboundType
  }
}
resource "azurerm_storage_account" "sa" {
  name                     = local.config.StorageAccount.Name
  resource_group_name      = azurerm_resource_group.rg[local.config.StorageAccount.ResourceGroupName].name
  location                 = local.config.Location
  account_tier             = local.config.StorageAccount.AccountTier
  account_replication_type = local.config.StorageAccount.AccountReplicationType
}

resource "azurerm_container_registry" "acr" {
  name                = local.config.ContainerRegistry.Name
  resource_group_name = azurerm_resource_group.rg[local.config.ContainerRegistry.ResourceGroupName].name
  location            = local.config.ContainerRegistry.Location
  sku                 = local.config.ContainerRegistry.Sku
  admin_enabled       = local.config.ContainerRegistry.AdminEnabled
}