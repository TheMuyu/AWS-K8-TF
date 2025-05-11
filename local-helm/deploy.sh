#!/bin/bash

# If tag not provided, try reading from .latest-tag
if [ -z "$1" ]; then
  if [ -f .latest-tag ]; then
    TAG=$(cat .latest-tag)
    echo "ℹ️  No tag provided. Using latest built tag: $TAG"
  else
    echo "❌ No tag provided and .latest-tag file not found."
    exit 1
  fi
else
  TAG=$1
fi

# Point Docker CLI to Minikube's Docker daemon
eval $(minikube -p minikube docker-env)

echo -e "\n⚙️ Enabling Minikube ingress (if not already enabled)..."
minikube addons enable ingress

echo -e "\n📦 Installing/upgrading Helm charts with image tag: $TAG"

helm upgrade --install backend ./backend \
  --set image.repository=local-backend \
  --set image.tag=$TAG

helm upgrade --install frontend ./frontend \
  --set image.repository=local-frontend \
  --set image.tag=$TAG

echo -e "\n🚀 Deployment complete using tag: $TAG"
