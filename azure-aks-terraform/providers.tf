terraform {
  required_version = ">=1.0"

  backend "azurerm" {
    resource_group_name   = "rg-able-hound"
    storage_account_name  = "markpersonalsite"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}