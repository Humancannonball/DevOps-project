variable "server_name" {
  type        = string
  description = "The name of the SQL Server."
}

variable "database_name" {
  type        = string
  description = "The name of the SQL Database."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group in which to create the SQL resources."
}

variable "location" {
  type        = string
  description = "Azure region for the SQL resources."
}

variable "requested_service_objective_name" {
  description = "The service objective name for the SQL database."
  type        = string
}

variable "administrator_login" {
  type        = string
  description = "Administrator username for the SQL Server."
}

variable "administrator_login_password" {
  type        = string
  sensitive   = true
  description = "Administrator password for the SQL Server."
}

variable "sku_name" {
  type        = string
  description = "The SKU name for the SQL Database."
}

variable "sql_version" {
  description = "The version of the Azure SQL Server."
  type        = string
}