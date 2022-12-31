# INFRASTRUCTURE STARTS HERE

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  address_space       = [var.vnet_cidr]
}

resource "azurerm_subnet" "main" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_virtual_network.main.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_cidr]
}

## CLUSTER RESOURCES

resource "azurerm_user_assigned_identity" "aks" {
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  name                = var.cluster_identity
}

data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

resource "azurerm_kubernetes_cluster" "main" {
  name                    = var.cluster_name
  location                = data.azurerm_resource_group.main.location
  resource_group_name     = data.azurerm_resource_group.main.name
  dns_prefix              = var.cluster_dns_prefix
  private_cluster_enabled = false
  # Allow the current client's public IP address only
  api_server_authorized_ip_ranges = ["${chomp(data.http.myip.response_body)}/32"]
  sku_tier                        = var.cluster_sku_tier

  default_node_pool {
    name           = "default"
    vm_size        = var.default_node_pool_vm_size
    vnet_subnet_id = azurerm_subnet.main.id
    node_count     = 1
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  network_profile {
    docker_bridge_cidr = var.cluster_docker_bridge_address
    dns_service_ip     = var.cluster_dns_service_ip_address
    network_plugin     = "azure"
    service_cidr       = var.cluster_service_ip_range
  }
}
