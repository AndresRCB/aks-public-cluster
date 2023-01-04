output "api_server_authorized_ip_ranges" {
  value       = azurerm_kubernetes_cluster.main.api_server_authorized_ip_ranges
  description = "CIDR range of IP addresses that can access the cluster's API server's public endpoint"
}

output "credentials_command" {
  value       = "az aks get-credentials --resource-group ${data.azurerm_resource_group.main.name} --name ${azurerm_kubernetes_cluster.main.name}"
  description = "Command to get the cluster's credentials with az cli"
}

output "id" {
  value       = azurerm_kubernetes_cluster.main.id
  description = "ID of the created kubernetes cluster"
}

output "invoke_command" {
  value       = "az aks command invoke --resource-group ${data.azurerm_resource_group.main.name} --name ${azurerm_kubernetes_cluster.main.name} --command \"kubectl get pods -n kube-system\""
  description = "Sample command to execute k8s commands on the cluster using az cli"
}

output "name" {
  value       = azurerm_kubernetes_cluster.main.name
  description = "Name of the kubernetes cluster created by this module"
}

output "resource_group_name" {
  value       = azurerm_kubernetes_cluster.main.resource_group_name
  description = "Name of the resource group where the cluster was created"
}
