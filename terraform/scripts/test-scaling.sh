#!/bin/bash

set -e

echo "🚀 Starting stress tests for backend and frontend deployments..."

# Create stress pod for backend
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: stress-backend
  namespace: backend
spec:
  containers:
  - name: stress
    image: progrium/stress
    command: ["stress"]
    args: ["--cpu", "1", "--timeout", "300"]
EOF

# Create stress pod for frontend
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: stress-frontend
  namespace: frontend
spec:
  containers:
  - name: stress
    image: progrium/stress
    command: ["stress"]
    args: ["--cpu", "1", "--timeout", "300"]
EOF

echo "✅ Stress pods created."

sleep 10

echo "👀 Watching backend and frontend HPA scaling..."
echo ""

kubectl get hpa -A --watch
