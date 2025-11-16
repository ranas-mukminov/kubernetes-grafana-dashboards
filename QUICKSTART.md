# Quick Start Guide

This guide helps you get the Grafana dashboards running in your Kubernetes cluster in under 5 minutes.

## Prerequisites

✅ Kubernetes cluster (1.24+)
✅ Prometheus with metrics collection enabled
✅ Grafana installed
✅ `kubectl` configured

## Installation

### Option 1: One-Command Install (Kustomize)

```bash
kubectl apply -k https://github.com/ranas-mukminov/kubernetes-grafana-dashboards
```

This creates ConfigMaps in the `monitoring` namespace with all dashboards.

### Option 2: Helm Chart

```bash
# Clone the repository
git clone https://github.com/ranas-mukminov/kubernetes-grafana-dashboards.git
cd kubernetes-grafana-dashboards

# Install with Helm
helm install grafana-dashboards ./charts/kubernetes-grafana-dashboards \
  -n monitoring --create-namespace
```

## Verify Installation

Check that ConfigMaps were created:

```bash
kubectl get configmaps -n monitoring -l grafana_dashboard=1
```

You should see 7 ConfigMaps:
- grafana-dashboard-cluster-resources
- grafana-dashboard-coredns
- grafana-dashboard-etcd
- grafana-dashboard-apiserver
- grafana-dashboard-certificates
- grafana-dashboard-namespace
- grafana-dashboard-pods

## Import to Grafana

### Automatic (with Grafana Sidecar)

If you're using kube-prometheus-stack or have Grafana sidecar enabled, dashboards will be automatically imported.

Verify in your Grafana deployment:
```yaml
sidecar:
  dashboards:
    enabled: true
    label: grafana_dashboard
```

### Manual Import

1. **Port forward to Grafana**:
   ```bash
   kubectl port-forward -n monitoring svc/grafana 3000:80
   ```

2. **Access Grafana**: http://localhost:3000

3. **Extract dashboard JSON**:
   ```bash
   kubectl get configmap grafana-dashboard-cluster-resources \
     -n monitoring -o jsonpath='{.data.*}' > dashboard.json
   ```

4. **Import in Grafana**:
   - Navigate to: Configuration → Dashboards → Import
   - Upload `dashboard.json`
   - Select Prometheus datasource
   - Click Import

## Verify Dashboards Work

1. Open the "Kubernetes Resource Usage - Cluster" dashboard
2. You should see:
   - CPU usage metrics
   - Memory usage metrics
   - Filesystem usage
3. If no data appears, check:
   - Prometheus is scraping metrics
   - Datasource is correctly configured
   - Time range is appropriate

## Quick Troubleshooting

### No Data in Dashboards

**Check Prometheus targets**:
```bash
kubectl port-forward -n monitoring svc/prometheus-operated 9090:9090
# Visit http://localhost:9090/targets
```

Ensure these targets are UP:
- kubelet (cAdvisor)
- kube-state-metrics
- node-exporter

**Test metrics**:
```bash
# Check if container metrics exist
kubectl exec -n monitoring prometheus-0 -- \
  promtool query instant http://localhost:9090 \
  'up{job="kubelet"}'
```

### Dashboards Not Appearing in Grafana

**Check sidecar logs**:
```bash
kubectl logs -n monitoring deployment/grafana -c dashboards-sidecar
```

**Verify ConfigMap labels**:
```bash
kubectl get configmap grafana-dashboard-cluster-resources \
  -n monitoring -o jsonpath='{.metadata.labels}'
```

Should include: `grafana_dashboard: "1"`

### Metrics Not Found

You may need to deploy ServiceMonitors:
```bash
kubectl apply -f https://raw.githubusercontent.com/ranas-mukminov/kubernetes-grafana-dashboards/main/examples/prometheus-servicemonitors.yaml
```

## Next Steps

- 📖 Read the full [README.md](README.md)
- 🔧 Customize with [examples/helm/values.yaml](examples/helm/values.yaml)
- 🚀 Deploy with GitOps using [examples/argocd/](examples/argocd/)
- 📊 Add recording rules from [examples/prometheus-rules/](examples/prometheus-rules/)

## Getting Help

- 🐛 Report issues: https://github.com/ranas-mukminov/kubernetes-grafana-dashboards/issues
- 💬 Ask questions: Create a discussion
- 📝 Documentation: See README.md for detailed docs

## Uninstall

```bash
# Kustomize
kubectl delete -k https://github.com/ranas-mukminov/kubernetes-grafana-dashboards

# Helm
helm uninstall grafana-dashboards -n monitoring
```

---

**Total Setup Time: ~5 minutes** ⏱️
