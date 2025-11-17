# Kubernetes Grafana Dashboards

Современные и комплексные дашборды Grafana для мониторинга Kubernetes с поддержкой Prometheus 2.40+ и Kubernetes 1.24+.

[[Русский]](#) | [[English](README.md)]

[![Validate Dashboards](https://github.com/ranas-mukminov/kubernetes-grafana-dashboards/actions/workflows/validate.yml/badge.svg)](https://github.com/ranas-mukminov/kubernetes-grafana-dashboards/actions/workflows/validate.yml)

## 📊 Дашборды

### Текущие дашборды

* **Cluster Overview** (`dashboards/cluster/`) - Использование ресурсов на уровне кластера
* **Namespace View** (`dashboards/namespace/`) - Метрики ресурсов по namespace
* **Pod Details** (`dashboards/pods/`) - Мониторинг ресурсов на уровне pod

Все дашборды включают:
- Селектор `$datasource` для работы с несколькими источниками данных
- Навигацию между дашбордами по ссылкам
- Поддержку федеративного Prometheus с метками `cluster`
- Современные панели временных рядов с градиентным режимом

### Схема навигации между дашбордами

```
k8s_resource_usage_cluster → (клик по ссылке дашборда) →
  k8s_resource_usage_namespace → (выбор namespace) →
    k8s_resource_usage_namespace_pods
```

## 🚀 Установка

### Быстрая установка с Kustomize

```bash
# Развернуть в namespace monitoring
kubectl apply -k https://github.com/ranas-mukminov/kubernetes-grafana-dashboards

# Или клонировать и настроить
git clone https://github.com/ranas-mukminov/kubernetes-grafana-dashboards
cd kubernetes-grafana-dashboards
kustomize build . | kubectl apply -f -
```

### Использование ArgoCD (GitOps)

```bash
kubectl apply -f examples/argocd/application.yaml
```

Подробнее в [examples/argocd/](examples/argocd/).

### Использование Helm Chart

```bash
# Установка из локального чарта
cd charts/kubernetes-grafana-dashboards
helm install grafana-dashboards . -n monitoring --create-namespace

# Или с пользовательскими значениями
helm install grafana-dashboards . -n monitoring \
  --set namespace=observability \
  --set dashboards.cluster.enabled=true
```

Подробнее в [charts/kubernetes-grafana-dashboards/README.md](charts/kubernetes-grafana-dashboards/README.md).

### Использование Helm с kube-prometheus-stack

Добавьте в ваш `values.yaml`:

```yaml
grafana:
  sidecar:
    dashboards:
      enabled: true
      label: grafana_dashboard
```

Затем разверните дашборды:

```bash
kubectl apply -k .
```

Полная конфигурация в [examples/helm/values.yaml](examples/helm/values.yaml).

### Использование Grafana Operator

```bash
kubectl apply -f examples/grafana-operator/
```

Подробнее в [examples/grafana-operator/](examples/grafana-operator/).

### Использование Terraform

```bash
cd examples/terraform
terraform init
terraform apply
```

Параметры конфигурации в [examples/terraform/](examples/terraform/).

### Ручная установка через ConfigMap

```bash
# Создание ConfigMap из файлов дашбордов
kubectl create configmap grafana-dashboard-cluster \
  --from-file=dashboards/cluster/k8s_resource_usage_cluster.json \
  -n monitoring

kubectl create configmap grafana-dashboard-namespace \
  --from-file=dashboards/namespace/k8s_resource_usage_namespace.json \
  -n monitoring

kubectl create configmap grafana-dashboard-pods \
  --from-file=dashboards/pods/k8s_resource_usage_namespace_pods.json \
  -n monitoring

# Добавление меток для Grafana sidecar
kubectl label configmap grafana-dashboard-cluster grafana_dashboard=1 -n monitoring
kubectl label configmap grafana-dashboard-namespace grafana_dashboard=1 -n monitoring
kubectl label configmap grafana-dashboard-pods grafana_dashboard=1 -n monitoring
```

## 📋 Предварительные требования

### Необходимые компоненты

- **Kubernetes**: 1.24+
- **Prometheus**: 2.40+ 
- **Grafana**: 9.0+
- **kube-state-metrics**: 2.x
- **Node Exporter**: Последняя версия
- **cAdvisor**: Интегрирован в kubelet

### Конфигурация Prometheus

Современная настройка использует ServiceMonitors (рекомендуется):

```bash
kubectl apply -f examples/prometheus-servicemonitors.yaml
```

Для устаревших scrape configs см. раздел [Устаревшая настройка Prometheus](#устаревшая-настройка-prometheus) ниже.

### Recording Rules (Опционально, но рекомендуется)

Разверните recording rules для улучшения производительности:

```bash
kubectl apply -f examples/prometheus-rules/recording-rules.yaml
```

## 🔧 Конфигурация

### Переменные шаблонов

Все дашборды поддерживают следующие переменные:

- `$datasource` - Селектор источника данных Prometheus
- `$cluster` - Фильтр по имени кластера (для федеративных настроек)
- `$namespace` - Фильтр по namespace
- `$resolution` - Разрешение времени для запросов (30s, 1m, 5m, 10m)

### Совместимость метрик

| Метрика | Старое имя | Новое имя | Версия |
|---------|------------|-----------|--------|
| Container CPU | `container_cpu_usage_seconds_total` | Без изменений | Стабильная |
| Container Memory | `container_memory_working_set_bytes` | Без изменений | Стабильная |
| Pod CPU Requests | `kube_pod_container_resource_requests_cpu_cores` | `kube_pod_container_resource_requests{resource="cpu"}` | kube-state-metrics 2.x |
| Pod Memory Requests | `kube_pod_container_resource_requests_memory_bytes` | `kube_pod_container_resource_requests{resource="memory"}` | kube-state-metrics 2.x |

## 📁 Структура репозитория

```
kubernetes-grafana-dashboards/
├── dashboards/
│   ├── cluster/              # Дашборды уровня кластера
│   ├── namespace/            # Дашборды уровня namespace
│   └── pods/                 # Дашборды уровня pod
├── provisioning/
│   └── dashboards/           # Конфигурации provisioning для Grafana
├── examples/
│   ├── argocd/              # Манифесты ArgoCD Application
│   ├── helm/                # Примеры values для Helm
│   ├── kustomize/           # Примеры Kustomize
│   ├── terraform/           # Модули Terraform
│   ├── grafana-operator/    # CRD для Grafana Operator
│   └── prometheus-rules/    # Recording и alerting rules
├── .github/workflows/       # CI/CD pipelines
├── kustomization.yaml       # Главный файл Kustomize
└── README.md
```

## 🧪 Разработка

### Валидация дашбордов

```bash
# Проверка синтаксиса JSON
for file in dashboards/**/*.json; do
  jq empty "$file" || echo "Неверный файл: $file"
done

# Тест сборки Kustomize
kustomize build . > /tmp/output.yaml
```

### CI/CD

Репозиторий включает автоматическую валидацию:
- Проверка синтаксиса JSON
- Валидация схемы дашбордов
- Линтинг YAML
- Тесты сборки Kustomize

См. [.github/workflows/validate.yml](.github/workflows/validate.yml)

## 📚 Матрица совместимости

| Компонент | Минимальная версия | Протестированная версия | Примечания |
|-----------|-------------------|------------------------|-----------|
| Kubernetes | 1.24 | 1.28 | Требуется metrics-server |
| Prometheus | 2.40 | 2.47 | Использует современные возможности PromQL |
| Grafana | 9.0 | 10.2 | Требуются панели временных рядов |
| kube-state-metrics | 2.0 | 2.10 | Имена метрик версии v2 |
| Prometheus Operator | 0.60 | 0.68 | Для ServiceMonitors |

## 🐛 Диагностика проблем

### Нет данных в дашбордах

1. **Проверьте цели Prometheus**:
   ```bash
   kubectl port-forward -n monitoring svc/prometheus-operated 9090:9090
   # Откройте http://localhost:9090/targets
   ```

2. **Убедитесь, что метрики собираются**:
   ```bash
   # Проверка метрик контейнеров
   kubectl exec -n monitoring prometheus-0 -- promtool query instant \
     http://localhost:9090 'up{job="kubelet"}'
   ```

3. **Проверьте ServiceMonitors**:
   ```bash
   kubectl get servicemonitors -n monitoring
   ```

### Дашборд не загружается

1. **Проверьте существование ConfigMap**:
   ```bash
   kubectl get configmap -n monitoring | grep grafana-dashboard
   ```

2. **Проверьте логи Grafana**:
   ```bash
   kubectl logs -n monitoring deployment/grafana -c grafana
   ```

3. **Проверьте dashboard sidecar** (если используется):
   ```bash
   kubectl logs -n monitoring deployment/grafana -c dashboards-sidecar
   ```

### Метрики устарели или отсутствуют

Этот репозиторий использует современные имена метрик. Если вы видите отсутствующие метрики:

1. Проверьте версию Prometheus: `kubectl exec -n monitoring prometheus-0 -- prometheus --version`
2. Проверьте версию kube-state-metrics: `kubectl get pods -n monitoring -l app.kubernetes.io/name=kube-state-metrics`
3. Обновитесь на kube-state-metrics 2.x, если используете 1.x

## 🤝 Участие в разработке

Приветствуются любые вклады! Пожалуйста:

1. Используйте conventional commits (например, `feat:`, `fix:`, `docs:`)
2. Валидируйте JSON перед коммитом
3. Обновляйте документацию для новых дашбордов
4. Добавляйте скриншоты для изменений UI

## 📄 Лицензия

См. файл [LICENSE](LICENSE) для деталей.

## 🔗 Ссылки

- [Документация Grafana](https://grafana.com/docs/)
- [Документация Prometheus](https://prometheus.io/docs/)
- [Helm Chart kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
- [Руководство по мониторингу Kubernetes](https://kubernetes.io/docs/tasks/debug-application-cluster/resource-metrics-pipeline/)

---

## Устаревшая настройка Prometheus

<details>
<summary>Нажмите для отображения устаревших scrape_configs</summary>

Мы стараемся следовать последней версии Prometheus. Дашборды работают с Prometheus 2.40+ на Kubernetes 1.24+.

### Устаревшие scrape_configs для Prometheus

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

**Примечание**: Современные развертывания должны использовать ServiceMonitors. См. [examples/prometheus-servicemonitors.yaml](examples/prometheus-servicemonitors.yaml).

</details>
