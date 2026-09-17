# Kubernetes Rolling Update and Rollback

## Session 10 – Kubernetes Core Objects

This assignment demonstrates a Kubernetes rolling update from Version 1 (v1) to Version 2 (v2), verification of the new version, rollout history, and rollback to Version 1.

---

## Objective

The objectives of this assignment are:

- Deploy Version 1 using a Kubernetes Deployment.
- Run four replicas of the application.
- Expose the application using a NodePort Service.
- Verify Version 1.
- Update the application from v1 to v2 using a RollingUpdate strategy.
- Observe old v1 Pods terminating and new v2 Pods running.
- Verify Version 2.
- Check Deployment rollout history.
- Roll back from v2 to v1.
- Verify that Version 1 is running again.

---

## Kubernetes Environment

| Item | Value |
|---|---|
| Kubernetes Platform | Docker Desktop Kubernetes |
| Kubernetes Context | docker-desktop |
| Kubernetes Version | v1.34.1 |
| Deployment | app-rolling |
| Replicas | 4 |
| Service | app-rolling-service |
| Service Type | NodePort |
| NodePort | 30010 |
| Application URL | http://localhost:30010 |

---

## Files in This Assignment

```text
01-rolling-update
├── README.md
├── deployment-v1.yaml
├── deployment-v2.yaml
├── service.yaml
├── version-1-pods-running.png
├── version-1-rollout-success.png
├── version-1-application-verification.png
├── version-2-rolling-update.png
├── version-2-pods-running.png
├── version-2-application-verification.png
├── rollout-history.png
├── rollback-successful.png
└── final-version-1-pods-and-verification.png
```

The screenshots are stored directly beside this README. No separate screenshots folder is required.

---

# Task 1: Deploy Version 1

The initial application was deployed using `deployment-v1.yaml`.

### Command

```bash
kubectl apply -f deployment-v1.yaml
```

### Actual Output

```text
deployment.apps/app-rolling created
```

The Deployment was checked using:

```bash
kubectl rollout status deployment/app-rolling
```

### Actual Output

```text
deployment "app-rolling" successfully rolled out
```

The Pods were verified using:

```bash
kubectl get pods -l app=app-rolling --show-labels
```

### Actual Pod Output

```text
NAME                           READY   STATUS    RESTARTS   AGE   LABELS
app-rolling-695b6d8768-86jq9   1/1     Running   0          35s   app=app-rolling,pod-template-hash=695b6d8768,version=v1
app-rolling-695b6d8768-jh25m   1/1     Running   0          35s   app=app-rolling,pod-template-hash=695b6d8768,version=v1
app-rolling-695b6d8768-srtc6   1/1     Running   0          35s   app=app-rolling,pod-template-hash=695b6d8768,version=v1
app-rolling-695b6d8768-wz7vz   1/1     Running   0          35s   app=app-rolling,pod-template-hash=695b6d8768,version=v1
```

All four replicas were running with the label `version=v1`.

### Screenshot – Version 1 Pods

![Version 1 Pods Running](version-1-pods-running.png)

### Screenshot – Version 1 Rollout Successful

![Version 1 Rollout Successful](version-1-rollout-success.png)

---

# Task 2: Create the Service

The application was exposed using a Kubernetes NodePort Service.

### Command

```bash
kubectl apply -f service.yaml
```

### Actual Output

```text
service/app-rolling-service created
```

The application was exposed through:

```text
http://localhost:30010
```

---

# Task 3: Verify Version 1

The application was accessed through the NodePort Service.

### Command

```bash
curl.exe http://localhost:30010
```

### Actual Output

```text
<html><body><h1>VERSION: v1</h1></body></html>
```

This confirmed that the application was serving Version 1.

### Screenshot – Version 1 Application Verification

![Version 1 Application Verification](version-1-application-verification.png)

---

# Task 4: Perform Rolling Update to Version 2

The Version 2 Deployment configuration was applied.

### Command

```bash
kubectl apply -f deployment-v2.yaml
```

### Actual Output

```text
deployment.apps/app-rolling configured
```

The rollout was monitored using:

```bash
kubectl rollout status deployment/app-rolling
```

### Actual Rollout Output

```text
Waiting for deployment "app-rolling" rollout to finish: 3 out of 4 new replicas have been updated...
Waiting for deployment "app-rolling" rollout to finish: 3 out of 4 new replicas have been updated...
Waiting for deployment "app-rolling" rollout to finish: 3 out of 4 new replicas have been updated...
Waiting for deployment "app-rolling" rollout to finish: 1 old replicas are pending termination...
Waiting for deployment "app-rolling" rollout to finish: 1 old replicas are pending termination...
deployment "app-rolling" successfully rolled out
```

### Screenshot – Version 2 Rolling Update

![Version 2 Rolling Update](version-2-rolling-update.png)

The Pods were then checked using:

```bash
kubectl get pods -l app=app-rolling --show-labels
```

### Actual Pod Output During the Rolling Update

```text
NAME                           READY   STATUS        RESTARTS   AGE    LABELS
app-rolling-695b6d8768-86jq9   1/1     Terminating   0          4m4s   app=app-rolling,pod-template-hash=695b6d8768,version=v1
app-rolling-695b6d8768-jh25m   1/1     Terminating   0          4m4s   app=app-rolling,pod-template-hash=695b6d8768,version=v1
app-rolling-695b6d8768-srtc6   1/1     Terminating   0          4m4s   app=app-rolling,pod-template-hash=695b6d8768,version=v1
app-rolling-695b6d8768-wz7vz   1/1     Terminating   0          4m4s   app=app-rolling,pod-template-hash=695b6d8768,version=v1
app-rolling-7cb896d7cb-8wxvp   1/1     Running       0          15s    app=app-rolling,pod-template-hash=7cb896d7cb,version=v2
app-rolling-7cb896d7cb-fbdhz   1/1     Running       0          12s    app=app-rolling,pod-template-hash=7cb896d7cb,version=v2
app-rolling-7cb896d7cb-glh6c   1/1     Running       0          18s    app=app-rolling,pod-template-hash=7cb896d7cb,version=v2
app-rolling-7cb896d7cb-sxwx6   1/1     Running       0          7s     app=app-rolling,pod-template-hash=7cb896d7cb,version=v2
```

The output shows the old v1 Pods entering `Terminating` while the new v2 Pods were `Running`.

### Screenshot – Version 2 Pods Running

![Version 2 Pods Running](version-2-pods-running.png)

---

# Task 5: Verify Version 2

After the rolling update completed, the application was accessed again.

### Command

```bash
curl.exe http://localhost:30010
```

### Actual Output

```text
<html><body><h1>VERSION: v2</h1></body></html>
```

This confirmed that Version 2 was being served through the Service.

### Screenshot – Version 2 Application Verification

![Version 2 Application Verification](version-2-application-verification.png)

---

# Task 6: Check Rollout History

The Deployment rollout history was checked using:

```bash
kubectl rollout history deployment/app-rolling
```

### Actual Output

```text
deployment.apps/app-rolling 
REVISION  CHANGE-CAUSE
1         <none>
2         <none>
```

The Deployment contained two revisions:

- Revision 1 – Version 1
- Revision 2 – Version 2

### Screenshot – Deployment Rollout History

![Deployment Rollout History](rollout-history.png)

---

# Task 7: Roll Back to Version 1

The Deployment was rolled back to the previous revision.

### Command

```bash
kubectl rollout undo deployment/app-rolling
```

### Actual Output

```text
deployment.apps/app-rolling rolled back
```

The rollback was monitored using:

```bash
kubectl rollout status deployment/app-rolling
```

### Actual Rollback Output

```text
Waiting for deployment "app-rolling" rollout to finish: 3 out of 4 new replicas have been updated...
Waiting for deployment "app-rolling" rollout to finish: 3 out of 4 new replicas have been updated...
Waiting for deployment "app-rolling" rollout to finish: 3 out of 4 new replicas have been updated...
Waiting for deployment "app-rolling" rollout to finish: 1 old replicas are pending termination...
Waiting for deployment "app-rolling" rollout to finish: 1 old replicas are pending termination...
deployment "app-rolling" successfully rolled out
```

### Screenshot – Rollback Successful

![Rollback Successful](rollback-successful.png)

The final Pods were checked using:

```bash
kubectl get pods -l app=app-rolling --show-labels
```

### Actual Final Pod Output

```text
NAME                           READY   STATUS        RESTARTS   AGE     LABELS
app-rolling-695b6d8768-hj84t   1/1     Running       0          11s     app=app-rolling,pod-template-hash=695b6d8768,version=v1
app-rolling-695b6d8768-hk7bx   1/1     Running       0          8s      app=app-rolling,pod-template-hash=695b6d8768,version=v1
app-rolling-695b6d8768-m2bt4   1/1     Running       0          13s     app=app-rolling,pod-template-hash=695b6d8768,version=v1
app-rolling-695b6d8768-ssf6s   1/1     Running       0          16s     app=app-rolling,pod-template-hash=695b6d8768,version=v1
app-rolling-7cb896d7cb-8wxvp   1/1     Terminating   0          4m11s   app=app-rolling,pod-template-hash=7cb896d7cb,version=v2
app-rolling-7cb896d7cb-fbdhz   1/1     Terminating   0          4m8s    app=app-rolling,pod-template-hash=7cb896d7cb,version=v2
app-rolling-7cb896d7cb-glh6c   1/1     Terminating   0          4m14s   app=app-rolling,pod-template-hash=7cb896d7cb,version=v2
app-rolling-7cb896d7cb-sxwx6   1/1     Terminating   0          4m3s    app=app-rolling,pod-template-hash=7cb896d7cb,version=v2
```

Finally, the application was checked again:

```bash
curl.exe http://localhost:30010
```

### Actual Final Application Output

```text
<html><body><h1>VERSION: v1</h1></body></html>
```

### Screenshot – Final Version 1 Pods and Verification

![Final Version 1 Pods and Verification](final-version-1-pods-and-verification.png)

This confirmed that the rollback restored Version 1.

---

# RollingUpdate Strategy

The Deployment used:

```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
```

### `maxSurge: 1`

At most one additional Pod can be created above the desired replica count during the update.

### `maxUnavailable: 0`

The rolling update controller does not voluntarily reduce the number of available Pods below the desired count while performing the update.

---

# Complete Assignment Flow

```text
Deploy Version 1
       |
       v
4 v1 Pods Running
       |
       v
Create NodePort Service
       |
       v
Verify VERSION: v1
       |
       v
Apply Version 2
       |
       v
Rolling Update
       |
       v
v1 Pods Terminating
       |
       v
v2 Pods Running
       |
       v
Verify VERSION: v2
       |
       v
Check Rollout History
       |
       v
Rollback Deployment
       |
       v
v2 Pods Terminating
       |
       v
4 v1 Pods Running
       |
       v
Verify VERSION: v1
```

---

# Kubernetes Objects Used

## Deployment

The Deployment manages the application Pods and controls the rolling update and rollback.

Deployment name:

```text
app-rolling
```

Replicas:

```text
4
```

Version labels:

```text
version=v1
```

and:

```text
version=v2
```

## Service

The Service exposes the application through a NodePort.

Service name:

```text
app-rolling-service
```

Service type:

```text
NodePort
```

NodePort:

```text
30010
```

Application URL:

```text
http://localhost:30010
```

## Pods

The Deployment runs four replicas.

During the initial deployment, the Pods used:

```text
version=v1
```

During the update, the new Pods used:

```text
version=v2
```

After rollback, the running Pods again used:

```text
version=v1
```

---

# Cleanup

If the Kubernetes resources need to be removed:

```bash
kubectl delete -f service.yaml
kubectl delete -f deployment-v1.yaml
```

---

# Final Result

The complete rolling update and rollback workflow was successfully demonstrated.

### Initial Version

```text
VERSION: v1
```

### Version After Rolling Update

```text
VERSION: v2
```

### Version After Rollback

```text
VERSION: v1
```

The assignment demonstrated:

- Kubernetes Deployments
- Kubernetes Pods
- Kubernetes Services
- NodePort
- Replica management
- Rolling updates
- Pod version labels
- Rollout status
- Rollout history
- Rollback

---

# Conclusion

The application was successfully deployed with four replicas, exposed through a NodePort Service, updated from Version 1 to Version 2 using a RollingUpdate strategy, and then rolled back to Version 1. The screenshots included in this README provide evidence for the deployment, version verification, rolling update, rollout history, rollback, and final state.
