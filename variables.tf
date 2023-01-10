variable "resource_group_name" {
  type        = string
  description = "Name of the existing resource group to create the cluster in"
}

variable "cluster_dns_prefix" {
  type        = string
  description = "DNS prefix for AKS cluster"
  default     = "akspubliccluster"
}

variable "cluster_dns_service_ip_address" {
  type        = string
  description = "IP address for the cluster's DNS service"
  default     = "172.16.16.254"
}

variable "cluster_docker_bridge_address" {
  type        = string
  description = "CIDR range for the docker bridge in the cluster"
  default     = "172.17.0.1/16"
}

variable "cluster_identity" {
  type        = string
  description = "Name of the MSI (Managed Service Identity) for the AKS cluster"
  default     = "identity-public-aks-cluster"
}

variable "cluster_name" {
  type        = string
  description = "Name for the public AKS cluster"
  default     = "aks-public-cluster"
}

variable "cluster_service_ip_range" {
  type        = string
  description = "CIDR range for the cluster's kube-system services"
  default     = "172.16.16.0/24"
}

variable "cluster_sku_tier" {
  type        = string
  description = "SKU tier selection between Free and Paid"
  default     = "Free"
}

variable "default_node_pool_vm_size" {
  type        = string
  description = "Size of nodes in the k8s cluster's default node pool"
  default     = "Standard_D2s_v3"
}

# variable "subnet_allow_inbound_http" {
#   type        = bool
#   description = "Create a security rule for the subnet to allow HTTP inbound traffic from the current TF client's IP address if true"
#   default     = true
# }

variable "subnet_cidr" {
  type        = string
  description = "CIDR range for the cluster subnet"
  default     = "172.16.0.0/20"
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet where all resources will be"
  default     = "subnet-public-aks"
}

variable "tags" {
  type        = map(string)
  description = "Any tags that should be present on the created resources"
  default     = {}
}

variable "vnet_cidr" {
  type        = string
  description = "CIDR range for the virtual network"
  default     = "172.16.0.0/16"
}

variable "vnet_name" {
  type        = string
  description = "Name of the virtual network where all resources will be"
  default     = "vnet-public-aks"
}
