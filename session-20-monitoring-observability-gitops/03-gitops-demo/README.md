# 🔄 Task 3: GitOps with Argo CD & Kubernetes

A practical demonstration of the **GitOps Operating Model**:
- **Git as the Single Source of Truth**: The desired state of the cluster is version-controlled in Git.
- **Declarative Configuration**: All workloads defined as Kubernetes YAML manifests.
- **Continuous Automated Reconciliation**: Argo CD continuously watches the Git repository and applies diffs to the cluster.
- **Self-Healing Against Drift**: When manual cluster changes occur (e.g., direct `kubectl scale`), Argo CD automatically overrides manual drift and restores the Git desired state.

---

## 🏗️ GitOps Architecture & Reconciliation Loop

```
                     Developer commits change (replicas: 2 -> 3)
                                      │
                                      ▼
                        +---------------------------+
                        |      Git Repository       |  <=== DESIRED STATE
                        +-------------+-------------+
                                      │
                                      │ (Watches Git every 3m / webhook)
                                      ▼
                        +---------------------------+
                        |      Argo CD Engine       |
                        +-------------+-------------+
                                      │
                         Compares Desired vs Actual
                                      │
                                      ▼
                        +---------------------------+
                        |     Kubernetes Cluster    |  <=== ACTUAL STATE
                        |    (session20-gitops)     |
                        +---------------------------+
```

---

## 📁 Manifests

1. **`gitops-manifests/namespace.yaml`**: Dedicated namespace `session20-gitops`.
2. **`gitops-manifests/deployment.yaml`**: NGINX deployment with 3 replicas and resource limits.
3. **`gitops-manifests/service.yaml`**: Internal ClusterIP service.
4. **`argocd/argocd-application.yaml`**: Argo CD CRD configured with `automated.selfHeal = true` and `automated.prune = true`.

---

## 🚀 Execution & Self-Healing Verification

```bash
# 1. Apply the Argo CD Application definition
kubectl apply -f argocd/argocd-application.yaml

# 2. Check Argo CD sync and health status
kubectl get applications -n argocd

# 3. Verify deployed Kubernetes workloads
kubectl get all -n session20-gitops

# 4. Demonstrate Self-Healing against manual configuration drift
# Simulate an unauthorized manual drift attempt:
kubectl scale deployment session20-gitops-app -n session20-gitops --replicas=1

# 5. Watch Argo CD detect drift and immediately restore 3 replicas
kubectl get deployment session20-gitops-app -n session20-gitops -w
```
