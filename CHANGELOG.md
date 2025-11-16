# 1.0.0 (2025-11-16)


### Features

* add Helm chart for easy installation ([c746d8a](https://github.com/ranas-mukminov/kubernetes-grafana-dashboards/commit/c746d8afb0bb18931b4854d56bca21a2915bdc99))
* add modern repository structure and deployment automation ([d8b7ee5](https://github.com/ranas-mukminov/kubernetes-grafana-dashboards/commit/d8b7ee5f88933d872ca31ed086bd1c0421e0ffbb))
* add new monitoring dashboards for CoreDNS, etcd, API Server, and certificates ([d29523d](https://github.com/ranas-mukminov/kubernetes-grafana-dashboards/commit/d29523d66566e2f1cf8a67deb20b7584c1048348))

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Restructured repository with organized directories (dashboards/, examples/, provisioning/)
- Kustomize support with kustomization.yaml
- ArgoCD Application manifest for GitOps deployments
- Helm values example for kube-prometheus-stack integration
- Helm chart for easy installation (charts/kubernetes-grafana-dashboards/)
- Grafana Operator CRD examples
- Terraform module for infrastructure-as-code deployment
- ServiceMonitor examples for modern Prometheus configuration
- Prometheus recording rules for improved query performance
- CI/CD pipeline for automated validation (.github/workflows/validate.yml)
- Semantic release workflow for automated versioning
- ConfigMap deployment examples with sidecar pattern
- Grafana dashboard provisioning configuration
- Comprehensive .gitignore file
- Updated README with installation methods and compatibility matrix
- Troubleshooting guide in README
- CONTRIBUTING.md with contribution guidelines
- New dashboards:
  - CoreDNS monitoring dashboard
  - etcd monitoring dashboard
  - API Server monitoring dashboard
  - Certificate expiration tracking dashboard
- Modern time series panels in new dashboards
- Template variables for cluster selection
- Screenshots directory with README

### Changed
- Moved dashboards to organized subdirectories (cluster/, namespace/, pods/)
- Updated README with modern deployment patterns
- Improved documentation structure
- Updated kustomization.yaml to include all dashboards

### Deprecated
- Legacy manual scrape_configs (still documented but ServiceMonitors recommended)

## [1.0.0] - Legacy

### Added
- Initial dashboard set from Bitnami Grafana dashboards
- k8s_resource_usage_cluster dashboard
- k8s_resource_usage_namespace dashboard  
- k8s_resource_usage_namespace_pods dashboard
- Basic README with Prometheus scrape_configs
