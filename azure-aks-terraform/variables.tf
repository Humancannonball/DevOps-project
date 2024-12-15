locals {
  config_file = "config.yml"
  config_file_content = fileexists(local.config_file) ? file(local.config_file) : "NoSettingsFileFound: true"
  config = yamldecode(local.config_file_content)
  # sql_admin_password_secret_name = local.config.SQLDatabase.AdministratorLoginPasswordSecretName
}

variable "location_map" {
  type = map(any)
  default = {
    eastus = "eastus"
    ea2    = "eastus2"
    weu    = "westeurope"
    neu    = "northeurope"
    cus    = "centralus"
  }
}

# variable "sql_admin_password" {
#   description = "The password for the SQL administrator"
#   type        = string
#   sensitive   = true
# }

variable "allow_vm_sku" {
  type = map(string)
  default = {
    d2s_v3 = "Standard_D2s_v3"
  }
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "subscription_id" {
  type = string
}