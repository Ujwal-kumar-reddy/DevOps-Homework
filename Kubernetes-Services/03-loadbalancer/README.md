# 03 - LoadBalancer Service

## Objective

Create a Kubernetes `LoadBalancer` Service and expose an NGINX application.

> **Environment:** Docker Desktop Kubernetes (local single-node cluster)

---

## Folder Structure

```text
03-loadbalancer/
├── app-deployment.yaml
├── service.yaml
├── README.md
└── screenshots/
    ├── 01-loadbalancer-pods-running.png
    ├── 02-loadbalancer-service.png
    ├── 03-loadbalancer-endpoints.png
    ├── 04-loadbalancer-service-details.png
    └── 05-loadbalancer-application-test.png
```

---

## 1. Application Deployment

The deployment creates 3 NGINX replicas.

### Manifest

`app-deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app-loadbalancer
  labels:
    app: web-loadbalancer
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-loadbalancer
  template:
    metadata:
      labels:
        app: web-loadbalancer
    spec:
      containers:
        - name: web-server
          image: nginx:1.25-alpine
          ports:
            - containerPort: 80
          resources:
            requests:
              cpu: "50m"
              memory: "64Mi"
            limits:
              cpu: "100m"
              memory: "128Mi"
```

### Apply

```powershell
kubectl apply -f Kubernetes-Services/03-loadbalancer/app-deployment.yaml
```

### Verification

```powershell
kubectl get pods -l app=web-loadbalancer -o wide
```

### Result

Three NGINX Pods were created and reached `Running` state.

| Pod | IP | Node | Status |
|---|---|---|---|
| web-app-loadbalancer-7f4b888fc7-9zqgz | 10.1.0.55 | docker-desktop | Running |
| web-app-loadbalancer-7f4b888fc7-fmstc | 10.1.0.54 | docker-desktop | Running |
| web-app-loadbalancer-7f4b888fc7-kd2rv | 10.1.0.56 | docker-desktop | Running |

### Screenshot

![LoadBalancer Pods](screenshots/01-loadbalancer-pods-running.png)

---

## 2. LoadBalancer Service

### Manifest

`service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-service-loadbalancer
  labels:
    app: web-loadbalancer
spec:
  type: LoadBalancer
  selector:
    app: web-loadbalancer
  ports:
    - name: http
      port: 80
      targetPort: 80
      protocol: TCP
```

### Apply

```powershell
kubectl apply -f Kubernetes-Services/03-loadbalancer/service.yaml
```

### Verify the Service

```powershell
kubectl get svc web-service-loadbalancer
```

### Actual Result

```text
NAME                       TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)
web-service-loadbalancer   LoadBalancer   10.110.76.214   <pending>     80:30933/TCP
```

The Service received:

- **Type:** LoadBalancer
- **ClusterIP:** `10.110.76.214`
- **Service Port:** `80`
- **NodePort:** `30933`
- **External IP:** `<pending>`

### Screenshot

![LoadBalancer Service](screenshots/02-loadbalancer-service.png)

---

## 3. Service Endpoints

The Service selector is:

```text
app=web-loadbalancer
```

Verify the endpoints:

```powershell
kubectl get endpoints web-service-loadbalancer
```

### Actual Result

```text
NAME                       ENDPOINTS
web-service-loadbalancer   10.1.0.54:80,10.1.0.55:80,10.1.0.56:80
```

The Service correctly discovered all 3 application Pods.

### Screenshot

![LoadBalancer Endpoints](screenshots/03-loadbalancer-endpoints.png)

---

## 4. Service Details

Run:

```powershell
kubectl describe svc web-service-loadbalancer
```

Important values from the actual output:

```text
Name:                     web-service-loadbalancer
Namespace:                default
Type:                     LoadBalancer
IP:                       10.110.76.214
Port:                     http  80/TCP
TargetPort:               80/TCP
NodePort:                 http  30933/TCP
Endpoints:                10.1.0.54:80,10.1.0.55:80,10.1.0.56:80
Session Affinity:         None
External Traffic Policy:  Cluster
Internal Traffic Policy:  Cluster
Events:                   <none>
```

### Screenshot

![LoadBalancer Service Details](screenshots/04-loadbalancer-service-details.png)

---

## 5. Application Verification

### Direct NodePort Test

The automatically assigned NodePort was `30933`.

The following test was attempted:

```powershell
curl.exe http://localhost:30933
```

Result:

```text
curl: (7) Failed to connect to localhost:30933 after 2267 ms: Could not connect to server
```

This is expected in this local Docker Desktop setup because a cloud-style external LoadBalancer IP is not provisioned.

### Local Verification Using Port-Forward

To verify that the LoadBalancer Service correctly routes traffic to the NGINX Pods, port-forward the Service:

```powershell
kubectl port-forward service/web-service-loadbalancer 8080:80
```

Output:

```text
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
```

Then open:

```text
http://localhost:8080
```

The NGINX welcome page was displayed successfully.

### Screenshot

![LoadBalancer Application Test](screenshots/05-loadbalancer-application-test.png)

---

## 6. Why Is EXTERNAL-IP `<pending>`?

This assignment was performed on a local Docker Desktop Kubernetes cluster rather than a cloud Kubernetes environment.

In cloud Kubernetes platforms, a `LoadBalancer` Service can request an external load balancer from the cloud provider. On this local Docker Desktop cluster, there is no cloud provider automatically provisioning an external load balancer, so:

```text
EXTERNAL-IP: <pending>
```

is expected.

The Service itself was successfully created as a `LoadBalancer`, received a ClusterIP and NodePort, discovered all 3 backend Pods, and successfully served the NGINX application when verified through `kubectl port-forward`.

---

## 7. Cleanup

After completing the screenshots, the temporary LoadBalancer resources were deleted:

```powershell
kubectl delete -f Kubernetes-Services/03-loadbalancer/service.yaml
kubectl delete -f Kubernetes-Services/03-loadbalancer/app-deployment.yaml
```

### Final verification

```powershell
kubectl get pods
kubectl get svc
```

The LoadBalancer deployment and Service were removed.

Existing Session 10 workloads remained running, including:

- `app-blue`
- `app-green`
- `app-canary`
- `app-recreate`
- `app-rolling`

Existing Services remained:

- `app-recreate-service`
- `app-rolling-service`
- `myapp-canary-service`
- `myapp-service`
- Kubernetes default `kubernetes` Service

---

## 8. Commands Summary

```powershell
# Create application
kubectl apply -f Kubernetes-Services/03-loadbalancer/app-deployment.yaml

# Verify Pods
kubectl get pods -l app=web-loadbalancer -o wide

# Create LoadBalancer Service
kubectl apply -f Kubernetes-Services/03-loadbalancer/service.yaml

# Verify Service
kubectl get svc web-service-loadbalancer

# Verify endpoints
kubectl get endpoints web-service-loadbalancer

# Inspect Service
kubectl describe svc web-service-loadbalancer

# Local application verification
kubectl port-forward service/web-service-loadbalancer 8080:80

# Cleanup
kubectl delete -f Kubernetes-Services/03-loadbalancer/service.yaml
kubectl delete -f Kubernetes-Services/03-loadbalancer/app-deployment.yaml

# Final verification
kubectl get pods
kubectl get svc
```

---

## Conclusion

The LoadBalancer Service was successfully created on the Docker Desktop Kubernetes cluster.

The exercise demonstrated:

- Creating a Deployment with 3 replicas
- Creating a `LoadBalancer` Service
- Understanding `ClusterIP`, `NodePort`, and `EXTERNAL-IP`
- Verifying Service endpoints
- Inspecting Service configuration
- Testing application connectivity locally with `kubectl port-forward`
- Understanding why `EXTERNAL-IP` remains `<pending>` on a local Docker Desktop cluster
- Cleaning up the temporary resources after verification
