terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.24"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.2"
    }
  }
}
