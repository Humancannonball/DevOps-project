resource "azurerm_resource_group" "rg" {
  for_each = { for key in local.config.ResourceGroups : key.Name => key }

  name     = each.value.Name
  location = var.location_map[local.config.Location]
  tags     = lookup(each.value, "Tags", null) != null ? each.value.Tags : {}
}

resource "azurerm_virtual_network" "vnet" {
  name                = local.config.VirtualNetwork.Name
  location            = var.location_map[local.config.Location]
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
  resource_group_name = azurerm_virtual_network.vnet.resource_group_name
  location = var.location_map[local.config.Location]
}

module "route-table" {
  for_each = { for key in local.config.RouteTables : key.Name => key }

  source = "./modules/route-table"

  route_table = each.value
  resource_group_name = azurerm_virtual_network.vnet.resource_group_name
  location = var.location_map[local.config.Location]
}

module "vnet-subnet" {
  for_each = { for key in local.config.VirtualNetwork.Subnets : key.Name => key }

  source = "./modules/vnet-subnet"

  subnet = each.value
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name = azurerm_virtual_network.vnet.resource_group_name
  location = var.location_map[local.config.Location]

  nsg_id = module.network-security-group[each.value.NetworkSecurityGroup].nsg_resource_id
  rt_id = module.route-table[each.value.RouteTable].rt_resource_id
}

resource "azurerm_user_assigned_identity" "k8s_identity" {
  name                = local.config.UserAssignedIdentity.Name
  resource_group_name = azurerm_resource_group.rg[local.config.UserAssignedIdentity.ResourceGroupName].name
  location            = var.location_map[local.config.Location]
}

resource "azurerm_role_assignment" "route_table_permission" {
  scope                = module.route-table["rt-aks"].rt_resource_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.k8s_identity.principal_id
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = local.config.AzureKubernetesCluster.Name
  location            = local.config.AzureKubernetesCluster.Location
  resource_group_name = local.config.AzureKubernetesCluster.ResourceGroupName
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
  location                 = var.location_map[local.config.Location]
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# resource "azurerm_key_vault" "keyvault" {
#   name                = local.config.KeyVault.Name
#   location            = var.location_map[local.config.Location]
#   resource_group_name = azurerm_resource_group.rg[local.config.KeyVault.ResourceGroupName].name
#   tenant_id           = var.tenant_id
#   sku_name            = local.config.KeyVault.SkuName
# }

# resource "azurerm_key_vault_secret" "sql_admin_password" {
#   name         = local.sql_admin_password_secret_name
#   value        = var.sql_admin_password
#   key_vault_id = azurerm_key_vault.keyvault.id
# }

# data "azurerm_key_vault_secret" "sql_admin_password" {
#   name         = local.sql_admin_password_secret_name
#   key_vault_id = azurerm_key_vault.keyvault.id
# }

# module "sql_database" {
#   source = "./modules/sql-database"

#   server_name                   = local.config.SQLDatabase.ServerName
#   database_name                 = local.config.SQLDatabase.Name
#   resource_group_name           = azurerm_resource_group.rg[local.config.SQLDatabase.ResourceGroupName].name
#   location                      = local.config.SQLDatabase.Location
#   sql_version                      = local.config.SQLDatabase.Version
#   administrator_login           = local.config.SQLDatabase.AdministratorLogin
#   administrator_login_password  = data.azurerm_key_vault_secret.sql_admin_password.value
#   sku_name                      = local.config.SQLDatabase.SkuName
#   requested_service_objective_name = local.config.SQLDatabase.RequestedServiceObjectiveName
# }

resource "azurerm_container_registry" "acr" {
  name                = local.config.ContainerRegistry.Name
  resource_group_name = local.config.ContainerRegistry.ResourceGroupName
  location            = var.location_map[local.config.Location]
  sku                 = local.config.ContainerRegistry.Sku
  admin_enabled       = local.config.ContainerRegistry.AdminEnabled
}