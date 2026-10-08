#!/bin/bash
set -e

echo "=== Deploying Yatri Full Demo (ConfigMap + Secret + Ingress) ==="

echo "1. Applying ConfigMap and Secret..."
kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml

echo "2. Deploying Frontend and Backend..."
kubectl apply -f frontend.yaml
kubectl apply -f backend.yaml

echo "3. Applying Ingress Routes..."
kubectl apply -f ingress.yaml

echo "4. Waiting for Deployments to become ready..."
kubectl rollout status deployment/yatri-frontend --timeout=90s
kubectl rollout status deployment/yatri-backend --timeout=90s

echo "=== Deployment Completed Successfully ==="
kubectl get pods,svc,ingress -l 'app in (yatri-frontend, yatri-backend, yatri-app)'
