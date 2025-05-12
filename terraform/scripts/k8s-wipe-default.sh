#!/bin/bash

set -e

echo "🚨 WARNING: This will delete ALL Kubernetes and Helm workloads in the 'default' namespace. Continuing in 5s..."
sleep 5

NAMESPACE="default"

echo "🧼 Deleting all Ingresses in $NAMESPACE..."
kubectl delete ingress --all -n $NAMESPACE --force --grace-period=0 || true

echo "🧼 Deleting all Services in $NAMESPACE..."
kubectl delete svc --all -n $NAMESPACE --force --grace-period=0 || true

echo "🧼 Deleting all Deployments in $NAMESPACE..."
kubectl delete deployment --all -n $NAMESPACE --force --grace-period=0 || true

echo "🧼 Deleting all StatefulSets in $NAMESPACE..."
kubectl delete statefulset --all -n $NAMESPACE --force --grace-period=0 || true

echo "🧼 Deleting all DaemonSets in $NAMESPACE..."
kubectl delete daemonset --all -n $NAMESPACE --force --grace-period=0 || true

echo "🧼 Deleting all ReplicaSets in $NAMESPACE..."
kubectl delete rs --all -n $NAMESPACE --force --grace-period=0 || true

echo "🧼 Deleting all ConfigMaps and Secrets in $NAMESPACE (excluding kube defaults)..."
kubectl delete configmap --all -n $NAMESPACE || true
kubectl delete secret --all -n $NAMESPACE || true

echo "🧼 Deleting all Pods in $NAMESPACE..."
kubectl delete pods --all -n $NAMESPACE --force --grace-period=0 || true

echo "🧼 Uninstalling all Helm releases in $NAMESPACE..."
helm list -n $NAMESPACE -q | xargs -r -n1 helm uninstall -n $NAMESPACE || true

echo "✅ Namespace '$NAMESPACE' wiped clean."
