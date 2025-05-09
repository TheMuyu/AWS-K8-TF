#!/bin/bash

# Point Docker CLI to Minikube's Docker daemon
eval $(minikube -p minikube docker-env)

echo -e "\n🔧 Building Docker images inside Minikube..."

# Build backend image
docker build -t local-backend ../backend/SumApi

# Build frontend image
docker build -t local-frontend -f ../frontend/sum-app/Dockerfile-local ../frontend/sum-app

echo -e "\n✅ Images built successfully."

# Enable ingress (safe to rerun even if already enabled)
echo -e "\n⚙️ Enabling Minikube ingress addon (if not already enabled)..."
minikube addons enable ingress

# Apply Kubernetes manifests
echo -e "\n📦 Applying Kubernetes deployments..."
kubectl apply -f ./k8s

# Force rollout restart (ensures new local image is used)
echo -e "\n🔄 Forcing deployment rollouts..."
kubectl rollout restart deployment frontend
kubectl rollout restart deployment backend

echo -e "\n🚀 Deployment complete and restarted."
