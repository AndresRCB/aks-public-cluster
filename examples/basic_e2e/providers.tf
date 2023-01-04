terraform {
  required_version = "~> 1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.24"
    }
  }
  backend "azurerm" {
    # Replace values here with your own
    resource_group_name  = "andrescotfrg"
    storage_account_name = "andrescotfacc"
    container_name       = "andrescotfcontainer"
    key                  = "akspubliccluster.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy       = false
      purge_soft_deleted_keys_on_destroy = false
      recover_soft_deleted_key_vaults    = false
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
