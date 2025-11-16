# Repository Summary

## Overview
This repository provides modern Grafana dashboards for comprehensive Kubernetes monitoring, compatible with Prometheus 2.40+ and Kubernetes 1.24+.

## Structure

```
kubernetes-grafana-dashboards/
├── dashboards/                    # Dashboard JSON files
│   ├── cluster/                   # Cluster-level dashboards
│   │   ├── k8s_resource_usage_cluster.json
│   │   ├── apiserver-monitoring.json
│   │   ├── coredns-monitoring.json
│   │   ├── etcd-monitoring.json
│   │   └── certificate-expiration.json
│   ├── namespace/                 # Namespace-level dashboards
│   │   └── k8s_resource_usage_namespace.json
│   └── pods/                      # Pod-level dashboards
│       └── k8s_resource_usage_namespace_pods.json
├── examples/                      # Deployment examples
│   ├── argocd/                    # GitOps with ArgoCD
│   ├── grafana-operator/          # Grafana Operator CRDs
│   ├── helm/                      # Helm values for kube-prometheus-stack
│   ├── terraform/                 # Terraform modules
│   ├── prometheus-rules/          # Recording and alerting rules
│   ├── configmap-deployment.yaml  # Manual ConfigMap deployment
│   └── prometheus-servicemonitors.yaml
├── provisioning/                  # Grafana provisioning configs
│   └── dashboards/
├── charts/                        # Helm chart
│   └── kubernetes-grafana-dashboards/
├── screenshots/                   # Dashboard screenshots
├── .github/workflows/             # CI/CD pipelines
│   ├── validate.yml               # Dashboard validation
│   └── release.yml                # Automated releases
├── kustomization.yaml             # Kustomize configuration
├── package.json                   # Semantic versioning
├── CHANGELOG.md                   # Version history
├── CONTRIBUTING.md                # Contribution guidelines
└── README.md                      # Main documentation
```

## Dashboards

### Cluster Level (5 dashboards)
1. **k8s_resource_usage_cluster** - Overall cluster resource utilization
2. **apiserver-monitoring** - Kubernetes API Server performance
3. **coredns-monitoring** - DNS service monitoring
4. **etcd-monitoring** - etcd database health
5. **certificate-expiration** - Certificate expiration tracking

### Namespace Level (1 dashboard)
1. **k8s_resource_usage_namespace** - Per-namespace resources

### Pod Level (1 dashboard)
1. **k8s_resource_usage_namespace_pods** - Individual pod monitoring

## Deployment Methods

### 1. Kustomize (Recommended)
```bash
kubectl apply -k https://github.com/ranas-mukminov/kubernetes-grafana-dashboards
```

### 2. Helm Chart
```bash
helm install grafana-dashboards ./charts/kubernetes-grafana-dashboards -n monitoring
```

### 3. ArgoCD (GitOps)
```bash
kubectl apply -f examples/argocd/application.yaml
```

### 4. Grafana Operator
```bash
kubectl apply -f examples/grafana-operator/
```

### 5. Terraform
```bash
cd examples/terraform && terraform apply
```

## Features

### Modern Dashboard Design
- Time series panels with gradient mode
- Template variables for datasource and cluster selection
- Drill-down navigation between related dashboards
- Responsive layouts

### Prometheus Integration
- Uses `$__rate_interval` for optimal query performance
- Compatible with recording rules
- ServiceMonitor examples for Prometheus Operator
- Pre-configured recording rules for common queries

### Automation
- JSON validation in CI/CD
- Automated semantic versioning
- Kustomize build validation
- Helm chart linting

## Metrics Sources

### Required Exporters
- **kubelet** (cAdvisor) - Container metrics
- **kube-state-metrics** - Kubernetes object state
- **node-exporter** - Node hardware/OS metrics
- **kube-apiserver** - API server metrics
- **coredns** - DNS metrics
- **etcd** - Database metrics

### Key Metrics Used
- `container_cpu_usage_seconds_total`
- `container_memory_working_set_bytes`
- `container_fs_usage_bytes`
- `kube_pod_container_resource_requests`
- `apiserver_request_total`
- `coredns_dns_requests_total`
- `etcd_server_has_leader`

## CI/CD Pipeline

### Validation Workflow
1. JSON syntax validation
2. Dashboard schema validation
3. YAML linting
4. Kustomize build test

### Release Workflow
1. Semantic commit analysis
2. Version bump
3. CHANGELOG update
4. GitHub release creation

## Version Management

Uses semantic versioning (semver):
- **MAJOR**: Breaking changes
- **MINOR**: New features (backwards compatible)
- **PATCH**: Bug fixes

Current version: 2.0.0

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on:
- Code style
- Commit conventions
- Testing procedures
- Pull request process

## Compatibility

| Component | Minimum | Tested |
|-----------|---------|--------|
| Kubernetes | 1.24 | 1.28 |
| Prometheus | 2.40 | 2.47 |
| Grafana | 9.0 | 10.2 |
| kube-state-metrics | 2.0 | 2.10 |

## License

Apache 2.0

## Maintainer

Ranas Mukminov
