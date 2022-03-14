resource azurerm_kubernetes_cluster "k8s_cluster" {
  dns_prefix          = "terragoat-${var.environment}"
  location            = var.location
  name                = "terragoat-aks-${var.environment}"
  resource_group_name = azurerm_resource_group.example.name
  identity {
    type = "SystemAssigned"
  }
  default_node_pool {
    name       = "default"
    vm_size    = "Standard_D2_v2"
    node_count = 2
  }
  addon_profile {
    azure_policy {
      enabled = true
    }
    oms_agent {
      enabled = true
    }
    kube_dashboard {
      enabled = true
    }
  }
  role_based_access_control {
    enabled = true
  }
  private_cluster_enabled = true
}