# INFRASTRUCTURE STARTS HERE

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "azurerm_virtual_network" "main" {
  address_space       = [var.vnet_cidr]
  location            = data.azurerm_resource_group.main.location
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = var.tags
}

resource "azurerm_subnet" "main" {
  address_prefixes     = [var.subnet_cidr]
  name                 = var.subnet_name
  resource_group_name  = azurerm_virtual_network.main.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
}

resource "azurerm_network_security_group" "main" {
  name                = "nsg-${azurerm_subnet.main.name}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowCidrBlockHTTPInbound"
    priority                   = 3000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "${chomp(data.http.myip.response_body)}/32"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

## CLUSTER RESOURCES

resource "azurerm_user_assigned_identity" "aks" {
  location            = data.azurerm_resource_group.main.location
  name                = var.cluster_identity
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = var.tags
}

data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

resource "azurerm_kubernetes_cluster" "main" {
  location                        = data.azurerm_resource_group.main.location
  name                            = var.cluster_name
  resource_group_name             = data.azurerm_resource_group.main.name
  api_server_authorized_ip_ranges = ["${chomp(data.http.myip.response_body)}/32"]
  dns_prefix                      = var.cluster_dns_prefix
  private_cluster_enabled         = false
  # Allow the current client's public IP address only
  sku_tier = var.cluster_sku_tier
  tags     = var.tags

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
