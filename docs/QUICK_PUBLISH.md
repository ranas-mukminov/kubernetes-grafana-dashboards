# Quick Publishing Checklist

## ✅ Step 1: Create Pull Request

**URL to create PR:**
```
https://github.com/ranas-mukminov/kubernetes-grafana-dashboards/pull/new/claude/grafana-dashboard-package-01LKf3Ce9jquHE32wbSYRDqW
```

**Set:**
- Base: `master`
- Compare: `claude/grafana-dashboard-package-01LKf3Ce9jquHE32wbSYRDqW`
- Title: `Transform into Production-Ready Open-Source Package`
- Description: Copy from `docs/PUBLISHING_GUIDE.md` section 1

**Then click "Create Pull Request"**

---

## ✅ Step 2: Publish on Grafana.com

### Before Publishing:

1. **Take screenshots:**
   ```bash
   cd docker
   docker-compose up -d
   # Go to http://localhost:3000 (admin/admin)
   # Take screenshots of each dashboard
   ```

2. **Prepare dashboard info:**
   - GitHub URL: `https://github.com/ranas-mukminov/kubernetes-grafana-dashboards`
   - Tags: `kubernetes`, `k8s`, `resources`, `monitoring`, `prometheus`, `bitnami`
   - Category: Kubernetes
   - Datasource: Prometheus

### Upload Dashboards:

**Go to:** https://grafana.com/grafana/dashboards/

**Upload in this order:**

1. **Cluster Dashboard**
   - File: `dashboards/k8s_resource_usage_cluster.json`
   - Name: `Kubernetes Resource Usage - Cluster`

2. **Namespace Dashboard**
   - File: `dashboards/k8s_resource_usage_namespace.json`
   - Name: `Kubernetes Resource Usage - Namespace`

3. **Pods Dashboard**
   - File: `dashboards/k8s_resource_usage_namespace_pods.json`
   - Name: `Kubernetes Resource Usage - Pods & Containers`

**Full details:** See `docs/PUBLISHING_GUIDE.md`

---

## ✅ Step 3: Update README

After publishing on Grafana.com, add dashboard IDs to README.md:

```markdown
[![Grafana Dashboard](https://img.shields.io/badge/Grafana-Dashboard-orange?logo=grafana)](https://grafana.com/grafana/dashboards/YOUR_ID)
```

---

## 📚 Full Guide

See `docs/PUBLISHING_GUIDE.md` for:
- Detailed PR creation steps
- Complete Grafana.com publishing workflow
- Post-publication checklist
- Promotion strategies
- Maintenance tips
