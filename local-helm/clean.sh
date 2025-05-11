#!/bin/bash

# Use Minikube Docker daemon
eval $(minikube -p minikube docker-env)

echo -e "\n🗑️ Deleting Helm releases..."
helm uninstall backend --namespace default 2>/dev/null
helm uninstall frontend --namespace default 2>/dev/null

echo -e "\n🗑️ Deleting Docker images from Minikube..."

for image in $(docker images --format "{{.Repository}}:{{.Tag}}" | grep -E "^local-(backend|frontend):"); do
  echo "🧽 Removing image: $image"
  docker rmi "$image" --force
done

echo -e "\n✅ Cleanup complete."
