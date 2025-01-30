locals {
  config_file = "config.yml"
  config_file_content = fileexists(local.config_file) ? file(local.config_file) : "NoSettingsFileFound: true"
  config = yamldecode(local.config_file_content)
}

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