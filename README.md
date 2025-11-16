# Kubernetes Resource Usage Dashboards

**Production-ready Grafana dashboards for comprehensive Kubernetes cluster resource monitoring and optimization.**

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Grafana](https://img.shields.io/badge/Grafana-4.6%2B-orange.svg)](https://grafana.com)
[![Prometheus](https://img.shields.io/badge/Prometheus-2.0%2B-red.svg)](https://prometheus.io)

## Why This Dashboard is Useful

Managing Kubernetes cluster resources efficiently is critical for cost optimization and performance. These dashboards provide a complete three-tier monitoring hierarchy—from cluster-wide overview down to individual container metrics—enabling DevOps teams to quickly identify resource bottlenecks, optimize workload distribution, and prevent outages before they happen. Built for intermediate DevOps engineers who want actionable insights in minutes, not hours.

## Features

- **Three-tier monitoring hierarchy**: Cluster → Namespace → Pod/Container drill-down with seamless navigation
- **Resource utilization tracking**: CPU, Memory, Filesystem, Network I/O, and Disk I/O metrics
- **Multi-datasource support**: Built-in `$datasource` variable for federated Prometheus setups
- **Top-N filtering**: Dynamically view top 5/10/20/100 resource consumers
- **Production-tested**: Battle-tested at Bitnami on multiple Kubernetes 1.8.x+ clusters
- **Interactive navigation**: Dashboards are interlinked for effortless exploration
- **Ready-to-use alerts**: Pre-configured Prometheus alerting rules for critical thresholds
- **Quick deployment**: Docker Compose demo environment for testing in under 5 minutes
- **Kubernetes-native**: Full scrape configs for real Kubernetes cluster deployment

## Quick Start

### Option 1: Docker Compose Demo (Fastest)

Perfect for testing and learning how the dashboards work:

```bash
# 1. Clone the repository
git clone https://github.com/ranas-mukminov/kubernetes-grafana-dashboards.git
cd kubernetes-grafana-dashboards

# 2. Start the demo environment
cd docker
docker-compose up -d

# 3. Access Grafana
# URL: http://localhost:3000
# Username: admin
# Password: admin

# 4. Import dashboards
# Go to Dashboards → Browse → Kubernetes folder
# The dashboards are automatically provisioned!
```

**What's included in the demo:**
- Prometheus with basic scrape configs
- Grafana with pre-configured datasource
- cAdvisor for container metrics
- Node Exporter for host metrics

### Option 2: Production Kubernetes Deployment

For deploying to a real Kubernetes cluster:

```bash
# 1. Clone the repository
git clone https://github.com/ranas-mukminov/kubernetes-grafana-dashboards.git
cd kubernetes-grafana-dashboards

# 2. Configure Prometheus
# Copy the Kubernetes-specific configuration
cp prometheus/prometheus-k8s.yml /path/to/your/prometheus/prometheus.yml

# 3. Update the cluster name in prometheus-k8s.yml
# Edit external_labels.cluster to match your cluster name

# 4. Apply alert rules
kubectl create configmap prometheus-k8s-alerts \
  --from-file=alerts/k8s-resource-alerts.yml \
  --namespace=monitoring

# 5. Reload Prometheus configuration
kubectl rollout restart deployment/prometheus -n monitoring

# 6. Import dashboards to Grafana
# - Open Grafana UI
# - Go to Dashboards → Import
# - Upload JSON files from dashboards/ directory in this order:
#   1. k8s_resource_usage_cluster.json
#   2. k8s_resource_usage_namespace.json
#   3. k8s_resource_usage_namespace_pods.json

# 7. Create Prometheus datasource variable
# - In Grafana: Configuration → Data Sources → Add data source
# - Select Prometheus
# - Set name to "Prometheus" (or configure $datasource variable accordingly)
```

## Repository Structure

```
kubernetes-grafana-dashboards/
├── dashboards/                      # Grafana dashboard JSON files
│   ├── k8s_resource_usage_cluster.json           # Cluster-level view
│   ├── k8s_resource_usage_namespace.json         # Namespace-level view
│   └── k8s_resource_usage_namespace_pods.json    # Pod/container-level view
├── prometheus/                      # Prometheus configuration files
│   ├── prometheus.yml               # Docker demo configuration
│   └── prometheus-k8s.yml           # Production Kubernetes configuration
├── alerts/                          # Prometheus alerting rules
│   └── k8s-resource-alerts.yml      # Resource usage alerts
├── docker/                          # Docker Compose demo
│   └── docker-compose.yml           # One-command demo environment
├── examples/                        # Example configurations
│   ├── datasource.yml               # Grafana datasource provisioning
│   └── dashboard-provider.yml       # Grafana dashboard provisioning
├── kubernetes/                      # Kubernetes manifests (optional)
├── docs/                            # Additional documentation
├── README.md                        # This file
└── LICENSE                          # Apache 2.0 license
```

## Configuration

### Required Metrics and Labels

These dashboards rely on metrics from **cAdvisor** (container metrics) and **Kubelet** (node metrics). Ensure your Prometheus is scraping:

| Metric Family | Source | Required Labels |
|---------------|--------|-----------------|
| `container_cpu_usage_seconds_total` | cAdvisor | `namespace`, `pod_name`, `container_name`, `instance` |
| `container_memory_working_set_bytes` | cAdvisor | `namespace`, `pod_name`, `container_name`, `instance` |
| `container_fs_usage_bytes` | cAdvisor | `device`, `namespace`, `pod_name` |
| `container_fs_limit_bytes` | cAdvisor | `device`, `namespace` |
| `container_network_receive_bytes_total` | cAdvisor | `namespace`, `pod_name` |
| `container_network_transmit_bytes_total` | cAdvisor | `namespace`, `pod_name` |
| `machine_cpu_cores` | Kubelet | `kubernetes_io_hostname`, `kubernetes_io_role` |
| `machine_memory_bytes` | Kubelet | `kubernetes_io_hostname` |
| `kube_pod_container_status_running` | kube-state-metrics | `namespace`, `pod`, `container` |

### Custom Label Requirements

The dashboards expect these custom labels (set via relabel_configs):

- `kubernetes_io_hostname`: Node hostname
- `kubernetes_io_role`: Node role (typically `node`, `master`, etc.)
- `cluster`: Cluster identifier (for multi-cluster setups)

**Example relabel config:**
```yaml
relabel_configs:
  - target_label: kubernetes_io_hostname
    replacement: 'your-node-name'
  - target_label: kubernetes_io_role
    replacement: 'node'
```

### Adapting to Your Cluster

1. **Cluster Name**: Update `external_labels.cluster` in `prometheus-k8s.yml`
2. **Filesystem Device Pattern**: Default is `^/dev/xvda.$` (AWS). Change to match your devices:
   - GCP: `^/dev/sda.$`
   - Azure: `^/dev/sd[a-z]$`
   - Generic: `^/dev/.*`
3. **Namespace Filtering**: Adjust regex patterns in dashboard variables if needed
4. **Scrape Intervals**: Default is 1m. Adjust based on your cluster size (larger clusters may need longer intervals)

## Dashboard Tour

### Dashboard 1: k8s_resource_usage_cluster

**Purpose:** Cluster-wide resource overview and per-node consumption.

| Panel / Section | What It Shows | How to Use It | Typical Problems It Helps Find |
|-----------------|---------------|---------------|--------------------------------|
| **Cluster CPU usage ratio** | Overall CPU utilization as % of total cluster capacity | Monitor trends to plan capacity; alert if >80% | Cluster CPU saturation, need to scale nodes |
| **Cluster memory usage ratio** | Overall memory utilization as % of total cluster capacity | Track memory pressure across cluster | Cluster memory exhaustion, memory leaks |
| **Cluster filesystem usage ratio** | Overall filesystem usage as % of total capacity | Prevent disk space issues | Disk space running out, need to clean up logs/images |
| **Per node CPU usage [s/s]** | CPU consumption per node in seconds/second | Identify nodes under heavy load; check for unbalanced workload distribution | Hot nodes, poor pod distribution, node failure |
| **Per node memory usage** | Memory usage per node in bytes | Spot nodes approaching memory limits | Memory pressure on specific nodes, eviction risk |
| **Per node filesystem usage** | Filesystem usage per node | Identify nodes with disk space issues | Local volume issues, image cache bloat |

**When to use:** Daily cluster health checks, capacity planning, identifying hardware bottlenecks.

**Navigation:** Click the "🔗" icon in the top-right to drill down to namespace or pod views.

---

### Dashboard 2: k8s_resource_usage_namespace

**Purpose:** Namespace-level resource consumption for multi-tenant analysis.

| Panel / Section | What It Shows | How to Use It | Typical Problems It Helps Find |
|-----------------|---------------|---------------|--------------------------------|
| **Cluster CPU usage for ns=$namespace** | CPU consumption by selected namespace(s) | Filter by namespace variable; compare multiple namespaces | Noisy neighbor problems, namespace resource quotas needed |
| **Cluster memory usage for ns=$namespace** | Memory consumption by selected namespace(s) | Track namespace memory trends over time | Namespace memory leaks, quota violations |
| **Cluster filesystem usage for ns=$namespace** | Filesystem usage by selected namespace(s) | Identify namespaces with heavy disk I/O or storage usage | Excessive logging, storage quota issues |

**Variables:**
- `$namespace`: Multi-select namespace filter (default: all)
- `$_interval`: Rate calculation interval (default: 2m)

**When to use:** Cost allocation, multi-tenancy monitoring, namespace quota planning, chargeback reporting.

**Navigation:** Select a namespace, then click "🔗" to view pod-level details for that namespace.

---

### Dashboard 3: k8s_resource_usage_namespace_pods

**Purpose:** Pod and container-level resource analysis with I/O and network metrics.

| Panel / Section | What It Shows | How to Use It | Typical Problems It Helps Find |
|-----------------|---------------|---------------|--------------------------------|
| **Top$top container CPU usage** | CPU usage of top N containers | Adjust `$top` variable (5/10/20/100); filter by namespace/pod/container | CPU-intensive containers, throttling, runaway processes |
| **Top$top container MEM usage** | Memory usage of top N containers | Identify memory-hungry containers; correlate with limits | Memory leaks, containers approaching OOMKill |
| **Top$top container IO +R -W [bytes/sec]** | Filesystem I/O read (+) and write (-) throughput | Spot I/O-heavy containers; positive=read, negative=write | Database bottlenecks, excessive logging, slow storage |
| **Top$top container IO +R -W [iops]** | Filesystem I/O operations per second | Identify IOPS-intensive workloads | Random I/O patterns, storage IOPS limits |
| **Top$top Pod Network +RX -TX [Bytes/sec]** | Network traffic in (+RX) and out (-TX) in bytes/sec | Monitor network bandwidth usage per pod | Network bottlenecks, DDoS, data transfer anomalies |
| **Top$top Pod Network +RX -TX [pkts/sec]** | Network packets in/out per second | Detect packet-intensive workloads (vs. byte-intensive) | UDP floods, packet loss, small packet overhead |

**Variables:**
- `$namespace`: Filter by namespace (multi-select)
- `$pod_name`: Filter by pod name pattern (supports wildcards)
- `$container_name`: Filter by container name
- `$top`: Number of top items to display (5, 10, 20, 100)
- `$role`: Kubernetes node role filter

**When to use:** Troubleshooting slow applications, optimizing resource requests/limits, identifying resource-intensive pods, capacity planning for specific workloads.

**Navigation:** Use filters to drill into specific namespaces or pods; link back to cluster/namespace views.

---

## Alerts

The repository includes production-ready Prometheus alerting rules in `alerts/k8s-resource-alerts.yml`. These alerts fire based on resource utilization thresholds and help prevent outages.

### Alert Categories

| Alert Name | Severity | Threshold | Duration | What It Means |
|------------|----------|-----------|----------|---------------|
| **ClusterCPUUsageHigh** | Warning | >80% | 5m | Cluster CPU usage above 80% - consider scaling |
| **ClusterCPUUsageCritical** | Critical | >90% | 5m | Cluster CPU critically high - immediate action needed |
| **ClusterMemoryUsageHigh** | Warning | >80% | 5m | Cluster memory usage above 80% - risk of OOM |
| **ClusterMemoryUsageCritical** | Critical | >90% | 5m | Cluster memory critically high - add nodes urgently |
| **ClusterFilesystemUsageHigh** | Warning | >80% | 5m | Cluster disk space running low - clean up required |
| **NodeCPUUsageHigh** | Warning | >80% | 5m | Specific node CPU high - check pod distribution |
| **NodeMemoryUsageHigh** | Warning | >80% | 5m | Specific node memory high - may need eviction |
| **NamespaceCPUUsageHigh** | Warning | >2 cores | 10m | Namespace using >2 CPU cores - check quotas |
| **NamespaceMemoryUsageHigh** | Warning | >4GB | 10m | Namespace using >4GB memory - check quotas |
| **PodCPUThrottlingHigh** | Warning | >25% | 5m | Pod being throttled >25% of time - increase CPU limits |
| **PodMemoryUsageNearLimit** | Warning | >90% | 5m | Pod near memory limit - risk of OOMKill |
| **PodRestartingFrequently** | Warning | >0.1/min | 5m | Pod restarting frequently - investigate crashes |
| **ContainerHighDiskIO** | Info | >50MB/s | 10m | Container doing heavy disk I/O - may impact performance |
| **PodHighNetworkTraffic** | Info | >100MB/s | 10m | Pod generating high network traffic - investigate |

### How Alerts Work

1. **Prometheus evaluates** alert rules every 30 seconds (configurable via `interval`)
2. **Alert enters "pending" state** when threshold is crossed
3. **Alert fires** after `for` duration (e.g., 5m) of continuous threshold violation
4. **Alertmanager receives** the alert and routes it (email, Slack, PagerDuty, etc.)
5. **Alert resolves** automatically when metric drops below threshold

### Customizing Alerts

Edit `alerts/k8s-resource-alerts.yml` to adjust:
- **Thresholds**: Change `> 0.80` to your preferred value
- **Duration**: Adjust `for: 5m` to make alerts more/less sensitive
- **Severity**: Modify `severity: warning|critical|info` labels
- **Add new alerts**: Copy existing rules and modify PromQL queries

**Example: Lower cluster CPU threshold to 70%:**
```yaml
- alert: ClusterCPUUsageHigh
  expr: |
    sum(rate(container_cpu_usage_seconds_total{...}[5m])) / sum(machine_cpu_cores{...})
    > 0.70  # Changed from 0.80
```

## Troubleshooting

### Dashboards Show "No Data"

**Possible causes:**
1. **Prometheus not scraping metrics**: Check Prometheus targets at `http://prometheus:9090/targets`
2. **Missing labels**: Verify metrics have required labels (`kubernetes_io_hostname`, `namespace`, etc.)
3. **Datasource not configured**: Ensure Grafana datasource points to correct Prometheus URL
4. **Wrong time range**: Check if you have data for the selected time period

**Fix:**
```bash
# Check Prometheus targets
curl http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | select(.health != "up")'

# Verify metrics are being scraped
curl http://localhost:9090/api/v1/query?query=container_cpu_usage_seconds_total | jq .
```

### Dashboards Show Partial Data

**Possible causes:**
1. **Filesystem device regex mismatch**: Default is `/dev/xvda.*` (AWS)
2. **Label name differences**: Your setup may use different label names
3. **Missing kube-state-metrics**: Required for namespace/pod filtering

**Fix:**
- Edit dashboard JSON and update device regex to match your environment
- Update relabel configs to add missing labels

### High Cardinality / Slow Queries

**Symptoms:** Dashboards load slowly or time out

**Possible causes:**
1. **Too many containers/pods**: Default queries load all data
2. **Short scrape intervals**: 15s intervals can generate excessive data
3. **Long time ranges**: Querying 30 days of high-resolution data is expensive

**Fix:**
- Use Top-N filtering (`$top` variable) in pod dashboard
- Increase `$_interval` variable (e.g., from 2m to 10m)
- Reduce dashboard time range
- Consider Prometheus recording rules for expensive queries

## Advanced Usage

### Multi-Cluster Monitoring (Federated Prometheus)

The dashboards support federated Prometheus setups using the `cluster` label:

1. **Add `cluster` label** to each Prometheus instance:
```yaml
global:
  external_labels:
    cluster: 'prod-us-east-1'
```

2. **Configure federation** in central Prometheus:
```yaml
scrape_configs:
  - job_name: 'federate'
    honor_labels: true
    metrics_path: '/federate'
    params:
      'match[]':
        - '{job=~"kubernetes_.*"}'
    static_configs:
      - targets:
        - 'prometheus-prod-us-east-1:9090'
        - 'prometheus-prod-eu-west-1:9090'
```

3. **Use `$datasource` variable** in Grafana to switch between clusters

### Recording Rules for Performance

For large clusters (>100 nodes), pre-aggregate metrics using recording rules:

```yaml
groups:
  - name: k8s_aggregations
    interval: 1m
    rules:
      - record: cluster:cpu_usage:ratio
        expr: |
          sum(rate(container_cpu_usage_seconds_total{id="/",kubernetes_io_role="node"}[5m]))
          /
          sum(machine_cpu_cores{kubernetes_io_role="node"})

      - record: cluster:memory_usage:ratio
        expr: |
          sum(container_memory_working_set_bytes{id="/"})
          /
          sum(machine_memory_bytes)
```

Then update dashboard queries to use `cluster:cpu_usage:ratio` instead of the full query.

## Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-improvement`)
3. Commit your changes (`git commit -m 'Add amazing improvement'`)
4. Push to the branch (`git push origin feature/amazing-improvement`)
5. Open a Pull Request

## Credits

These dashboards are based on the original work by **jjo** at Bitnami, published on [Grafana.com Dashboard #3119](https://grafana.com/dashboards/3119). This repository extends the original dashboards with:
- Complete deployment automation (Docker Compose + Kubernetes)
- Production-ready Prometheus alerting rules
- Comprehensive documentation and troubleshooting guides
- Grafana datasource/dashboard provisioning
- Enhanced configuration examples

**Original Author:** jjo @ Bitnami
**Original Dashboard:** https://grafana.com/dashboards/3119
**Repository Maintainer:** Ranas Mukminov

Special thanks to:
- The Bitnami team for battle-testing these dashboards in production
- The Prometheus and Grafana communities for excellent monitoring tools
- All contributors who helped improve these dashboards

## License

This project is licensed under the **Apache License 2.0** - see the [LICENSE](LICENSE) file for details.

The original Grafana dashboards by jjo @ Bitnami were shared publicly on Grafana.com. This repository packages and extends that work with additional tooling, documentation, and automation while preserving attribution to the original author.

---

**Questions or issues?** Open an issue on [GitHub](https://github.com/ranas-mukminov/kubernetes-grafana-dashboards/issues).

**Found this useful?** Give it a ⭐ on GitHub!
