# 📊 Task 1: Monitoring Demo & Resource Metrics

A hands-on demonstration of cloud-native application monitoring on Kubernetes:
- **Metrics**: Exposing Prometheus metrics (`Counter`, `Gauge`, `Histogram`)
- **Logs**: Structured JSON logging and container stdout streams
- **Alerts**: Prometheus Alertmanager rules for CPU and Memory thresholds
- **Resource Utilization**: CPU and Memory requests/limits and utilization tracking
- **Application Health**: Liveness and Readiness probe status

---

## 🛠️ Components

1. **Python Application**: Exposing `/metrics` via `prometheus_client` on port 8000.
2. **Kubernetes Deployment**: Annotated with `prometheus.io/scrape = "true"` and configured with CPU (`100m` request / `250m` limit) and Memory (`128Mi` request / `256Mi` limit).
3. **Prometheus Alerting Rules**:
   - `HighCPUUtilization` (> 80% quota for 2 min)
   - `HighMemoryUsage` (> 85% limit for 2 min)
   - `AppHealthCheckFailure` (endpoint failure)

---

## 🚀 Execution & Verification Commands

```bash
# 1. Apply application manifests
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# 2. Verify pods and resource metrics
kubectl get pods -o wide -l app=monitoring-demo-app
kubectl top pods -l app=monitoring-demo-app

# 3. Test application metrics endpoint
curl http://localhost:30800/metrics
curl http://localhost:30800/health

# 4. View application logs
kubectl logs -l app=monitoring-demo-app --tail=25
```
