output "configmap_names" {
  description = "Names of created ConfigMaps"
  value       = [for cm in kubernetes_config_map.grafana_dashboards : cm.metadata[0].name]
}

output "namespace" {
  description = "Namespace where dashboards are deployed"
  value       = kubernetes_namespace.monitoring.metadata[0].name
}
