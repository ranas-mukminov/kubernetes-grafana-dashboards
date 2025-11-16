terraform {
  required_version = ">= 1.0"
  
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }
}

provider "kubernetes" {
  # Configuration options
  # Can be set via environment variables or config file
}

resource "kubernetes_config_map" "grafana_dashboards" {
  for_each = var.dashboard_files
  
  metadata {
    name      = "grafana-dashboard-${each.key}"
    namespace = var.namespace
    
    labels = {
      "${var.grafana_dashboard_label}" = "1"
      "app.kubernetes.io/name"         = "grafana-dashboards"
      "app.kubernetes.io/component"    = "monitoring"
    }
  }
  
  data = {
    "${basename(each.value)}" = file("${path.module}/../../${each.value}")
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
    
    labels = {
      "name" = var.namespace
    }
  }
}
