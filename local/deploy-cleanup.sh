#!/bin/bash

# Use Minikube's Docker daemon
eval $(minikube -p minikube docker-env)

echo -e "\n🧹 Deleting Kubernetes resources in ./k8s..."
kubectl delete -f ./k8s --ignore-not-found

echo -e "\n🗑️ Removing Docker images from Minikube..."
docker rmi local-backend local-frontend --force 2>/dev/null

echo -e "\n📦 Removing PostgreSQL PVC and associated PV..."
kubectl delete pvc postgres-pvc --ignore-not-found
kubectl delete pv $(kubectl get pv --no-headers | awk '/postgres-pvc/ {print $1}') --ignore-not-found

echo -e "\n✅ Cleanup complete."
