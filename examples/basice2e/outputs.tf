output "test_aks_cluster_id" {
  value = module.aks_public_cluster.id
}

output "test_api_server_authorized_ip_ranges" {
  value = module.aks_public_cluster.api_server_authorized_ip_ranges
}
