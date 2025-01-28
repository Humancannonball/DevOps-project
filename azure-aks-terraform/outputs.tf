output "resource_group_names" {
  description = "Names of the resource groups."
  value       = [for rg in azurerm_resource_group.rg : rg.name]
}

# AKS Cluster Details
output "kubernetes_cluster_name" {
  value       = azurerm_kubernetes_cluster.k8s.name
  description = "The name of the AKS Kubernetes cluster."
}

output "kubernetes_cluster_fqdn" {
  value       = azurerm_kubernetes_cluster.k8s.fqdn
  description = "The FQDN of the AKS Kubernetes cluster."
}

# Kubeconfig (Sensitive)
output "kube_config" {
  value       = azurerm_kubernetes_cluster.k8s.kube_config_raw
  description = "The raw kubeconfig for the Kubernetes cluster."
  sensitive   = true
}

# Azure Container Registry (ACR) Details
output "acr_login_server" {
  value       = azurerm_container_registry.acr.login_server
  description = "The login server URL for the Azure Container Registry."
}

output "acr_admin_username" {
  value       = azurerm_container_registry.acr.admin_username
  description = "The admin username for the Azure Container Registry."
}

output "acr_admin_password" {
  value       = azurerm_container_registry.acr.admin_password
  description = "The admin password for the Azure Container Registry."
  sensitive   = true
}

# Storage Account Details
output "storage_account_name" {
  value       = azurerm_storage_account.sa.name
  description = "The name of the Azure Storage Account."
}