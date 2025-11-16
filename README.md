# Kubernetes Grafana Dashboards

Modern, comprehensive Grafana dashboards for Kubernetes monitoring with support for Prometheus 2.40+ and Kubernetes 1.24+.

[![Validate Dashboards](https://github.com/ranas-mukminov/kubernetes-grafana-dashboards/actions/workflows/validate.yml/badge.svg)](https://github.com/ranas-mukminov/kubernetes-grafana-dashboards/actions/workflows/validate.yml)

## 📊 Dashboards

### Current Dashboards

* **Cluster Overview** (`dashboards/cluster/`) - Cluster-wide resource utilization
* **Namespace View** (`dashboards/namespace/`) - Per-namespace resource metrics  
* **Pod Details** (`dashboards/pods/`) - Pod-level resource monitoring

All dashboards feature:
- `$datasource` selector for multi-datasource setups
- Drill-down navigation between dashboards
- Support for federated Prometheus with `cluster` labels
- Modern time series panels with gradient mode

### Dashboard Navigation Flow

```
k8s_resource_usage_cluster → (click dashboard link) →
  k8s_resource_usage_namespace → (select namespace) →
    k8s_resource_usage_namespace_pods
```

## 🚀 Installation

### Quick Start with Kustomize

```bash
# Deploy to monitoring namespace
kubectl apply -k https://github.com/ranas-mukminov/kubernetes-grafana-dashboards

# Or clone and customize
git clone https://github.com/ranas-mukminov/kubernetes-grafana-dashboards
cd kubernetes-grafana-dashboards
kustomize build . | kubectl apply -f -
```

### Using ArgoCD (GitOps)

```bash
kubectl apply -f examples/argocd/application.yaml
```

See [examples/argocd/](examples/argocd/) for full configuration.

### Using Helm (kube-prometheus-stack)

Add to your `values.yaml`:

```yaml
grafana:
  sidecar:
    dashboards:
      enabled: true
      label: grafana_dashboard
```

Then deploy dashboards:

```bash
kubectl apply -k .
```

See [examples/helm/values.yaml](examples/helm/values.yaml) for complete configuration.

### Using Grafana Operator

```bash
kubectl apply -f examples/grafana-operator/
```

See [examples/grafana-operator/](examples/grafana-operator/) for more details.

### Using Terraform

```bash
cd examples/terraform
terraform init
terraform apply
```

See [examples/terraform/](examples/terraform/) for configuration options.

### Manual ConfigMap Installation

```bash
# Create ConfigMaps from dashboard files
kubectl create configmap grafana-dashboard-cluster \
  --from-file=dashboards/cluster/k8s_resource_usage_cluster.json \
  -n monitoring

kubectl create configmap grafana-dashboard-namespace \
  --from-file=dashboards/namespace/k8s_resource_usage_namespace.json \
  -n monitoring

kubectl create configmap grafana-dashboard-pods \
  --from-file=dashboards/pods/k8s_resource_usage_namespace_pods.json \
  -n monitoring

# Label for Grafana sidecar
kubectl label configmap grafana-dashboard-cluster grafana_dashboard=1 -n monitoring
kubectl label configmap grafana-dashboard-namespace grafana_dashboard=1 -n monitoring
kubectl label configmap grafana-dashboard-pods grafana_dashboard=1 -n monitoring
```

## 📋 Prerequisites

### Required Components

- **Kubernetes**: 1.24+
- **Prometheus**: 2.40+ 
- **Grafana**: 9.0+
- **kube-state-metrics**: 2.x
- **Node Exporter**: Latest
- **cAdvisor**: Integrated in kubelet

### Prometheus Configuration

Modern setup uses ServiceMonitors (recommended):

```bash
kubectl apply -f examples/prometheus-servicemonitors.yaml
```

For legacy scrape configs, see [README.md - Legacy Setup](#legacy-prometheus-setup) section below.

### Recording Rules (Optional but Recommended)

Deploy recording rules for better performance:

```bash
kubectl apply -f examples/prometheus-rules/recording-rules.yaml
```

## 🔧 Configuration

### Template Variables

All dashboards support these variables:

- `$datasource` - Prometheus datasource selector
- `$cluster` - Cluster name filter (for federated setups)
- `$namespace` - Namespace filter
- `$resolution` - Time resolution for queries (30s, 1m, 5m, 10m)

### Metrics Compatibility

| Metric | Old Name | New Name | Version |
|--------|----------|----------|---------|
| Container CPU | `container_cpu_usage_seconds_total` | Same | Stable |
| Container Memory | `container_memory_working_set_bytes` | Same | Stable |
| Pod CPU Requests | `kube_pod_container_resource_requests_cpu_cores` | `kube_pod_container_resource_requests{resource="cpu"}` | kube-state-metrics 2.x |
| Pod Memory Requests | `kube_pod_container_resource_requests_memory_bytes` | `kube_pod_container_resource_requests{resource="memory"}` | kube-state-metrics 2.x |

## 📁 Repository Structure

```
kubernetes-grafana-dashboards/
├── dashboards/
│   ├── cluster/              # Cluster-level dashboards
│   ├── namespace/            # Namespace-level dashboards
│   └── pods/                 # Pod-level dashboards
├── provisioning/
│   └── dashboards/           # Grafana provisioning configs
├── examples/
│   ├── argocd/              # ArgoCD Application manifests
│   ├── helm/                # Helm values examples
│   ├── kustomize/           # Kustomize examples
│   ├── terraform/           # Terraform modules
│   ├── grafana-operator/    # Grafana Operator CRDs
│   └── prometheus-rules/    # Recording and alerting rules
├── .github/workflows/       # CI/CD pipelines
├── kustomization.yaml       # Main Kustomize file
└── README.md
```

## 🧪 Development

### Validate Dashboards

```bash
# Validate JSON syntax
for file in dashboards/**/*.json; do
  jq empty "$file" || echo "Invalid: $file"
done

# Test Kustomize build
kustomize build . > /tmp/output.yaml
```

### CI/CD

The repository includes automated validation:
- JSON syntax checking
- Dashboard schema validation
- YAML linting
- Kustomize build tests

See [.github/workflows/validate.yml](.github/workflows/validate.yml)

## 📚 Compatibility Matrix

| Component | Minimum Version | Tested Version | Notes |
|-----------|----------------|----------------|-------|
| Kubernetes | 1.24 | 1.28 | Requires metrics-server |
| Prometheus | 2.40 | 2.47 | Uses modern PromQL features |
| Grafana | 9.0 | 10.2 | Time series panels required |
| kube-state-metrics | 2.0 | 2.10 | v2 metric names |
| Prometheus Operator | 0.60 | 0.68 | For ServiceMonitors |

## 🐛 Troubleshooting

### No Data in Dashboards

1. **Check Prometheus targets**:
   ```bash
   kubectl port-forward -n monitoring svc/prometheus-operated 9090:9090
   # Visit http://localhost:9090/targets
   ```

2. **Verify metrics are being scraped**:
   ```bash
   # Check for container metrics
   kubectl exec -n monitoring prometheus-0 -- promtool query instant \
     http://localhost:9090 'up{job="kubelet"}'
   ```

3. **Check ServiceMonitors**:
   ```bash
   kubectl get servicemonitors -n monitoring
   ```

### Dashboard Not Loading

1. **Verify ConfigMap exists**:
   ```bash
   kubectl get configmap -n monitoring | grep grafana-dashboard
   ```

2. **Check Grafana logs**:
   ```bash
   kubectl logs -n monitoring deployment/grafana -c grafana
   ```

3. **Verify dashboard sidecar** (if using):
   ```bash
   kubectl logs -n monitoring deployment/grafana -c dashboards-sidecar
   ```

### Metrics Deprecated or Missing

This repository uses modern metric names. If you see missing metrics:

1. Check your Prometheus version: `kubectl exec -n monitoring prometheus-0 -- prometheus --version`
2. Verify kube-state-metrics version: `kubectl get pods -n monitoring -l app.kubernetes.io/name=kube-state-metrics`
3. Update to kube-state-metrics 2.x if using 1.x

## 🤝 Contributing

Contributions are welcome! Please:

1. Use conventional commits (e.g., `feat:`, `fix:`, `docs:`)
2. Validate JSON before committing
3. Update documentation for new dashboards
4. Add screenshots for UI changes

## 📄 License

See [LICENSE](LICENSE) file for details.

## 🔗 Links

- [Grafana Documentation](https://grafana.com/docs/)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [kube-prometheus-stack Helm Chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
- [Kubernetes Monitoring Guide](https://kubernetes.io/docs/tasks/debug-application-cluster/resource-metrics-pipeline/)

---

## Legacy Prometheus Setup

<details>
<summary>Click to expand legacy scrape_configs</summary>

We try to follow latest upstream Prometheus. The dashboards work with Prometheus 2.40+ on Kubernetes 1.24+.

### Legacy Prometheus scrape_configs

```yaml
scrape_configs:
- job_name: kubernetes_apiservers
  scrape_interval: 1m
  scrape_timeout: 30s
  metrics_path: /metrics
  scheme: https
  kubernetes_sd_configs:
  - role: endpoints
  bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
  tls_config:
    ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
  relabel_configs:
  - source_labels: [__meta_kubernetes_namespace, __meta_kubernetes_service_name, __meta_kubernetes_endpoint_port_name]
    regex: default;kubernetes;https
    action: keep

- job_name: kubernetes_cadvisor
  scrape_interval: 1m
  scrape_timeout: 30s
  metrics_path: /metrics/cadvisor
  scheme: https
  kubernetes_sd_configs:
  - role: node
  bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
  tls_config:
    ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
  relabel_configs:
  - action: labelmap
    regex: __meta_kubernetes_node_label_(.+)
  - target_label: __address__
    replacement: kubernetes.default.svc.cluster.local:443
  - source_labels: [__meta_kubernetes_node_name]
    target_label: __metrics_path__
    replacement: /api/v1/nodes/${1}/proxy/metrics/cadvisor

- job_name: kubernetes_nodes
  scrape_interval: 1m
  scrape_timeout: 30s
  metrics_path: /metrics
  scheme: https
  kubernetes_sd_configs:
  - role: node
  bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
  tls_config:
    ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
  relabel_configs:
  - action: labelmap
    regex: __meta_kubernetes_node_label_(.+)
  - target_label: __address__
    replacement: kubernetes.default.svc.cluster.local:443
  - source_labels: [__meta_kubernetes_node_name]
    target_label: __metrics_path__
    replacement: /api/v1/nodes/${1}/proxy/metrics
```

**Note**: Modern deployments should use ServiceMonitors instead. See [examples/prometheus-servicemonitors.yaml](examples/prometheus-servicemonitors.yaml).

</details>
