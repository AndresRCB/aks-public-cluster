data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

resource "azurerm_user_assigned_identity" "aks" {
  location            = data.azurerm_resource_group.main.location
  name                = var.cluster_identity
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = var.tags
}

resource "azurerm_role_assignment" "aks_network_contributor" {
  scope                = azurerm_virtual_network.main.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_kubernetes_cluster" "main" {
  location            = data.azurerm_resource_group.main.location
  name                = var.cluster_name
  resource_group_name = data.azurerm_resource_group.main.name
  # Allow the current client's public IP address only
  api_server_authorized_ip_ranges = ["${chomp(data.http.myip.response_body)}/32"]
  dns_prefix                      = var.cluster_dns_prefix
  private_cluster_enabled         = false
  sku_tier                        = var.cluster_sku_tier
  tags                            = var.tags
  oidc_issuer_enabled             = true
  workload_identity_enabled       = true

  default_node_pool {
    name           = "default"
    vm_size        = var.default_node_pool_vm_size
    node_count     = 1
    tags           = var.tags
    vnet_subnet_id = azurerm_subnet.main.id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  network_profile {
    network_plugin     = "azure"
    dns_service_ip     = var.cluster_dns_service_ip_address
    docker_bridge_cidr = var.cluster_docker_bridge_address
    service_cidr       = var.cluster_service_ip_range
  }
}
