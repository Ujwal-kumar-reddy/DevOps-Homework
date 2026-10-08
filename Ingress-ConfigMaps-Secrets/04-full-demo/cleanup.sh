#!/bin/bash
echo "=== Cleaning Up Yatri Full Demo Resources ==="
kubectl delete -f ingress.yaml --ignore-not-found
kubectl delete -f backend.yaml --ignore-not-found
kubectl delete -f frontend.yaml --ignore-not-found
kubectl delete -f secret.yaml --ignore-not-found
kubectl delete -f configmap.yaml --ignore-not-found
echo "=== Cleanup Completed ==="
