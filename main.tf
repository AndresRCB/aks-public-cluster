data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "http" "myip" {
  url = "https://api.ipify.org"
}

resource "azurerm_user_assigned_identity" "aks" {
  location            = data.azurerm_resource_group.main.location
  name                = var.cluster_identity
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = var.tags
}

resource "azurerm_role_assignment" "aks_network_contributor" {
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
  scope                = azurerm_virtual_network.main.id
  role_definition_name = "Network Contributor"
}

resource "azurerm_kubernetes_cluster" "main" {
  location                      = data.azurerm_resource_group.main.location
  name                          = var.cluster_name
  resource_group_name           = data.azurerm_resource_group.main.name
  dns_prefix                    = var.cluster_dns_prefix
  oidc_issuer_enabled           = true
  private_cluster_enabled       = false
  public_network_access_enabled = true
  sku_tier                      = var.cluster_sku_tier
  tags                          = var.tags
  workload_identity_enabled     = true

  default_node_pool {
    name           = "default"
    vm_size        = var.default_node_pool_vm_size
    node_count     = 1
    tags           = var.tags
    vnet_subnet_id = azurerm_subnet.main.id
  }

  api_server_access_profile {
    # Allow the current client's public IP address only
    authorized_ip_ranges = var.authorized_ip_cidr_range == "" ? ["${chomp(data.http.myip.response_body)}/32"] : [var.authorized_ip_cidr_range]
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = false
  }

  network_profile {
    network_plugin = "azure"
    dns_service_ip = var.cluster_dns_service_ip_address
    service_cidr   = var.cluster_service_ip_range
  }
}
