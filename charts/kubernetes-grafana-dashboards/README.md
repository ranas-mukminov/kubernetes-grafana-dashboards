# Kubernetes Grafana Dashboards Helm Chart

This Helm chart deploys Grafana dashboards for Kubernetes monitoring as ConfigMaps.

## Prerequisites

- Kubernetes 1.24+
- Helm 3.0+
- Grafana with dashboard sidecar enabled (or manual import)

## Installation

### Add Helm Repository (when published)

```bash
helm repo add kubernetes-grafana-dashboards https://ranas-mukminov.github.io/kubernetes-grafana-dashboards
helm repo update
```

### Install from local chart

```bash
# Clone the repository
git clone https://github.com/ranas-mukminov/kubernetes-grafana-dashboards.git
cd kubernetes-grafana-dashboards/charts/kubernetes-grafana-dashboards

# Install the chart
helm install grafana-dashboards . -n monitoring --create-namespace
```

### Install with custom values

```bash
helm install grafana-dashboards . -n monitoring \
  --set namespace=observability \
  --set dashboards.cluster.enabled=true \
  --set dashboards.namespace.enabled=false
```

## Configuration

The following table lists the configurable parameters of the chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `namespace` | Namespace where ConfigMaps will be created | `monitoring` |
| `createNamespace` | Create namespace if it doesn't exist | `false` |
| `labels.grafana_dashboard` | Label for Grafana sidecar | `"1"` |
| `dashboards.cluster.enabled` | Enable cluster dashboards | `true` |
| `dashboards.cluster.files` | List of cluster dashboard files | See values.yaml |
| `dashboards.namespace.enabled` | Enable namespace dashboards | `true` |
| `dashboards.namespace.files` | List of namespace dashboard files | See values.yaml |
| `dashboards.pods.enabled` | Enable pod dashboards | `true` |
| `dashboards.pods.files` | List of pod dashboard files | See values.yaml |
| `annotations` | Additional annotations for ConfigMaps | `{}` |

## Grafana Configuration

### With Sidecar (Recommended)

If using kube-prometheus-stack or Grafana with sidecar enabled:

```yaml
grafana:
  sidecar:
    dashboards:
      enabled: true
      label: grafana_dashboard
      labelValue: "1"
```

Dashboards will be automatically imported.

### Manual Import

1. Get the ConfigMap:
```bash
kubectl get configmap grafana-dashboard-cluster-k8s-resource-usage-cluster \
  -n monitoring -o jsonpath='{.data}' > dashboard.json
```

2. Import in Grafana UI: Configuration → Dashboards → Import

## Dashboards Included

### Cluster Level
- **k8s_resource_usage_cluster** - Cluster-wide resource utilization
- **coredns-monitoring** - CoreDNS metrics and health
- **etcd-monitoring** - etcd database monitoring
- **apiserver-monitoring** - Kubernetes API Server metrics
- **certificate-expiration** - Certificate expiration tracking

### Namespace Level
- **k8s_resource_usage_namespace** - Per-namespace resource metrics

### Pod Level
- **k8s_resource_usage_namespace_pods** - Pod-level resource monitoring

## Uninstallation

```bash
helm uninstall grafana-dashboards -n monitoring
```

## Upgrading

```bash
helm upgrade grafana-dashboards . -n monitoring
```

## License

Apache 2.0
