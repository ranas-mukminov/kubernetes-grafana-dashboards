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

### Changed
- Moved dashboards to organized subdirectories (cluster/, namespace/, pods/)
- Updated README with modern deployment patterns
- Improved documentation structure

### Deprecated
- Legacy manual scrape_configs (still documented but ServiceMonitors recommended)

## [1.0.0] - Legacy

### Added
- Initial dashboard set from Bitnami Grafana dashboards
- k8s_resource_usage_cluster dashboard
- k8s_resource_usage_namespace dashboard  
- k8s_resource_usage_namespace_pods dashboard
- Basic README with Prometheus scrape_configs
