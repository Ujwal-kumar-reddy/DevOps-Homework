# Kubernetes Rolling Update and Rollback

## Session 10 -- Kubernetes Core Objects

This assignment demonstrates how to deploy an application using
Kubernetes, expose it using a NodePort Service, perform a rolling update
from Version 1 (v1) to Version 2 (v2), verify the update, view rollout
history, and finally roll back to Version 1.

------------------------------------------------------------------------

## Objective

The objectives of this assignment are:

-   Deploy an application using a Kubernetes Deployment.
-   Run multiple replicas of the application.
-   Expose the application using a Kubernetes Service.
-   Verify Version 1 of the application.
-   Perform a rolling update from v1 to v2.
-   Observe old pods terminating and new pods starting.
-   Verify Version 2 after the update.
-   Check the Deployment rollout history.
-   Roll back the Deployment from v2 to v1.
-   Verify that Version 1 is running again.

------------------------------------------------------------------------

## Kubernetes Environment

  Item                  Value
  --------------------- ---------------------------
  Kubernetes Platform   Docker Desktop Kubernetes
  Kubernetes Context    docker-desktop
  Kubernetes Version    v1.34.1
  Deployment            app-rolling
  Replicas              4
  Service               app-rolling-service
  Service Type          NodePort
  NodePort              30010
  Application URL       http://localhost:30010

------------------------------------------------------------------------

## Folder Structure

All files for this assignment are kept inside the `01-rolling-update`
folder.

``` text
K8s-Core-Objects
└── 01-rolling-update
    ├── deployment-v1.yaml
    ├── deployment-v2.yaml
    ├── service.yaml
    ├── README.md
    ├── SS1.png
    ├── SS2.png
    ├── SS3.png
    ├── SS4.png
    ├── SS5.png
    └── SS6.png
```

### Screenshot Mapping

The screenshots are stored directly inside the same folder as this
README.

  Screenshot   What it shows
  ------------ ----------------------------------------------------------
  `SS1.png`    Version 1 Deployment rollout and 4 running v1 pods
  `SS2.png`    Version 1 application verification
  `SS3.png`    Version 2 rolling update and v2 pods
  `SS4.png`    Version 2 application verification
  `SS5.png`    Deployment rollout history showing revisions 1 and 2
  `SS6.png`    Rollback to v1, final v1 pods, and final v1 verification

------------------------------------------------------------------------

# Task 1: Deploy Version 1

The initial application was deployed using `deployment-v1.yaml`.

### Command

``` bash
kubectl apply -f deployment-v1.yaml
```

### Actual Output

``` text
deployment.apps/app-rolling created
```

The Deployment was then checked using:

``` bash
kubectl rollout status deployment/app-rolling
```

### Actual Output

``` text
deployment "app-rolling" successfully rolled out
```

The Pods were verified using:

``` bash
kubectl get pods -l app=app-rolling --show-labels
```

### Actual Output

``` text
NAME                           READY   STATUS    RESTARTS   AGE   LABELS
app-rolling-695b6d8768-86jq9   1/1     Running   0          35s   app=app-rolling,pod-template-hash=695b6d8768,version=v1
app-rolling-695b6d8768-jh25m   1/1     Running   0          35s   app=app-rolling,pod-template-hash=695b6d8768,version=v1
app-rolling-695b6d8768-srtc6   1/1     Running   0          35s   app=app-rolling,pod-template-hash=695b6d8768,version=v1
app-rolling-695b6d8768-wz7vz   1/1     Running   0          35s   app=app-rolling,pod-template-hash=695b6d8768,version=v1
```

All four replicas were running and had the label `version=v1`.

### SS1 -- Version 1 Deployment and Pods

![SS1 - Version 1 Deployment and Pods](SS1.png)

------------------------------------------------------------------------

# Task 2: Create the Service

The application was exposed using a Kubernetes NodePort Service.

### Command

``` bash
kubectl apply -f service.yaml
```

### Actual Output

``` text
service/app-rolling-service created
```

The Service uses NodePort `30010`, so the application can be accessed
at:

``` text
http://localhost:30010
```

------------------------------------------------------------------------

# Task 3: Verify Version 1

The application was accessed through the NodePort Service.

### Command

``` bash
curl.exe http://localhost:30010
```

### Actual Output

``` text
<html><body><h1>VERSION: v1</h1></body></html>
```

This confirmed that the application was serving Version 1.

### SS2 -- Version 1 Application Verification

![SS2 - Version 1 Application Verification](SS2.png)

------------------------------------------------------------------------

# Task 4: Perform Rolling Update to Version 2

The Version 2 Deployment configuration was applied.

### Command

``` bash
kubectl apply -f deployment-v2.yaml
```

### Actual Output

``` text
deployment.apps/app-rolling configured
```

The rollout was monitored using:

``` bash
kubectl rollout status deployment/app-rolling
```

### Actual Rollout Output

``` text
Waiting for deployment "app-rolling" rollout to finish: 3 out of 4 new replicas have been updated...
Waiting for deployment "app-rolling" rollout to finish: 3 out of 4 new replicas have been updated...
Waiting for deployment "app-rolling" rollout to finish: 3 out of 4 new replicas have been updated...
Waiting for deployment "app-rolling" rollout to finish: 1 old replicas are pending termination...
Waiting for deployment "app-rolling" rollout to finish: 1 old replicas are pending termination...
deployment "app-rolling" successfully rolled out
```

The Pods were checked using:

``` bash
kubectl get pods -l app=app-rolling --show-labels
```

### Actual Pod Output During/After Rolling Update

``` text
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

The output shows the rolling update process:

-   The new v2 Pods were created.
-   The old v1 Pods entered the `Terminating` state.
-   The new v2 Pods reached the `Running` state.
-   The Deployment rollout completed successfully.

### SS3 -- Version 2 Rolling Update

![SS3 - Version 2 Rolling Update](SS3.png)

------------------------------------------------------------------------

# Task 5: Verify Version 2

After the rolling update completed, the application was accessed again.

### Command

``` bash
curl.exe http://localhost:30010
```

### Actual Output

``` text
<html><body><h1>VERSION: v2</h1></body></html>
```

This confirmed that the Service was now serving Version 2.

### SS4 -- Version 2 Application Verification

![SS4 - Version 2 Application Verification](SS4.png)

------------------------------------------------------------------------

# Task 6: Check Rollout History

The Deployment rollout history was checked using:

``` bash
kubectl rollout history deployment/app-rolling
```

### Actual Output

``` text
deployment.apps/app-rolling 
REVISION  CHANGE-CAUSE
1         <none>
2         <none>
```

The Deployment therefore contained two revisions:

-   Revision 1 -- Version 1
-   Revision 2 -- Version 2

The change cause is shown as `<none>` because no
`kubernetes.io/change-cause` annotation was added to the Deployment.

### SS5 -- Rollout History

![SS5 - Rollout History](SS5.png)

------------------------------------------------------------------------

# Task 7: Roll Back to Version 1

The Deployment was rolled back to the previous revision.

### Command

``` bash
kubectl rollout undo deployment/app-rolling
```

### Actual Output

``` text
deployment.apps/app-rolling rolled back
```

The rollback was then monitored using:

``` bash
kubectl rollout status deployment/app-rolling
```

### Actual Rollback Output

``` text
Waiting for deployment "app-rolling" rollout to finish: 3 out of 4 new replicas have been updated...
Waiting for deployment "app-rolling" rollout to finish: 3 out of 4 new replicas have been updated...
Waiting for deployment "app-rolling" rollout to finish: 3 out of 4 new replicas have been updated...
Waiting for deployment "app-rolling" rollout to finish: 1 old replicas are pending termination...
Waiting for deployment "app-rolling" rollout to finish: 1 old replicas are pending termination...
deployment "app-rolling" successfully rolled out
```

The Pods were then checked:

``` bash
kubectl get pods -l app=app-rolling --show-labels
```

### Actual Final Pod Output

``` text
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

``` bash
curl.exe http://localhost:30010
```

### Actual Final Application Output

``` text
<html><body><h1>VERSION: v1</h1></body></html>
```

This confirmed that the rollback successfully restored Version 1.

### SS6 -- Rollback and Final Version 1

![SS6 - Rollback and Final Version 1](SS6.png)

------------------------------------------------------------------------

# RollingUpdate Strategy

The Deployment used the following strategy:

``` yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
```

### `maxSurge: 1`

At most one additional Pod can be created above the desired replica
count during the update.

Since the Deployment has 4 replicas, Kubernetes can temporarily have an
additional Pod while replacing old Pods.

### `maxUnavailable: 0`

The rolling update controller does not voluntarily reduce the number of
available Pods below the desired count while performing the update.

The actual Pod lifecycle can still show old Pods in `Terminating` state
while the rollout is completing.

------------------------------------------------------------------------

# Assignment Flow

The complete workflow performed in this assignment was:

``` text
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

------------------------------------------------------------------------

# Kubernetes Objects Used

## 1. Deployment

The Deployment manages the application Pods and controls the rolling
update process.

Deployment name:

``` text
app-rolling
```

Replicas:

``` text
4
```

The Deployment used labels to distinguish the application version:

``` text
version=v1
```

and:

``` text
version=v2
```

------------------------------------------------------------------------

## 2. Service

The Service exposes the application to the host machine.

Service name:

``` text
app-rolling-service
```

Service type:

``` text
NodePort
```

NodePort:

``` text
30010
```

Application URL:

``` text
http://localhost:30010
```

------------------------------------------------------------------------

## 3. Pods

The Deployment created four replicas.

During the v1 deployment, all Pods had:

``` text
version=v1
```

During the v2 deployment, the new Pods had:

``` text
version=v2
```

After rollback, the running Pods again had:

``` text
version=v1
```

------------------------------------------------------------------------

# Files Used

## `deployment-v1.yaml`

Defines the initial Version 1 Deployment.

The application responds with:

``` text
VERSION: v1
```

## `deployment-v2.yaml`

Defines Version 2 of the same Deployment.

The application responds with:

``` text
VERSION: v2
```

## `service.yaml`

Defines the NodePort Service that exposes the application through:

``` text
http://localhost:30010
```

## `README.md`

Contains the complete documentation, commands, actual outputs,
explanations, and screenshots for the assignment.

------------------------------------------------------------------------

# Cleanup

If the Kubernetes resources need to be removed after completing the
assignment, use:

``` bash
kubectl delete -f service.yaml
kubectl delete -f deployment-v1.yaml
```

Note that `deployment-v1.yaml` refers to the same Deployment name
(`app-rolling`). The current Deployment specification at the time of
deletion does not matter for deletion; Kubernetes deletes the named
Deployment object.

------------------------------------------------------------------------

# Final Result

The Kubernetes rolling update and rollback workflow was completed
successfully.

### Version 1

``` text
VERSION: v1
```

### Version 2 after Rolling Update

``` text
VERSION: v2
```

### Version 1 after Rollback

``` text
VERSION: v1
```

The assignment demonstrated:

-   Kubernetes Deployments
-   Kubernetes Pods
-   Kubernetes Services
-   NodePort
-   Replica management
-   Rolling updates
-   Pod version labels
-   Deployment rollout status
-   Deployment rollout history
-   Kubernetes rollback

------------------------------------------------------------------------

# Conclusion

This assignment demonstrated how Kubernetes can update an application
gradually using a `RollingUpdate` strategy instead of replacing all
application Pods at once. The application was successfully updated from
Version 1 to Version 2, the new version was verified through the
Service, the Deployment history was inspected, and the application was
successfully rolled back to Version 1.

All six screenshots are embedded directly in this README and are stored
in the same `01-rolling-update` folder.
