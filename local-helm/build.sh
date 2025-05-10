#!/bin/bash

# Ensure a tag is provided
if [ -z "$1" ]; then
  echo "❌ Usage: ./build-images.sh <tag> is missing!"
  exit 1
fi

TAG=$1

# Use Minikube Docker daemon
eval $(minikube -p minikube docker-env)

echo -e "\n🔧 Building Docker images with tag: $TAG"

docker build -t local-backend:$TAG ../backend/SumApi
docker build -t local-frontend:$TAG -f ../frontend/sum-app/Dockerfile-local ../frontend/sum-app

# Save latest tag to a file
echo $TAG > .latest-tag

echo -e "\n✅ Images built: local-backend:$TAG, local-frontend:$TAG"
