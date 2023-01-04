resource "azurerm_resource_group" "main" {
  location = var.location
  name     = var.resource_group_name
}

module "aks_public_cluster" {
  source = "../.."

  resource_group_name = azurerm_resource_group.main.name
  depends_on = [
    azurerm_resource_group.main
  ]
}
