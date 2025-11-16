variable "namespace" {
  description = "Kubernetes namespace for Grafana dashboards"
  type        = string
  default     = "monitoring"
}

variable "grafana_dashboard_label" {
  description = "Label to identify Grafana dashboards"
  type        = string
  default     = "grafana_dashboard"
}

variable "dashboard_files" {
  description = "Map of dashboard names to file paths"
  type        = map(string)
  default = {
    "cluster"   = "dashboards/cluster/k8s_resource_usage_cluster.json"
    "namespace" = "dashboards/namespace/k8s_resource_usage_namespace.json"
    "pods"      = "dashboards/pods/k8s_resource_usage_namespace_pods.json"
  }
}
