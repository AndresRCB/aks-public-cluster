terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.24"
    }

    azapi = {
      source  = "azure/azapi"
      version = "~> 1.2"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.2"
    }
  }
}
