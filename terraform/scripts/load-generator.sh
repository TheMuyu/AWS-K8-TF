#!/bin/bash

echo "🔄 Deleting any existing 'load-generator' pod..."
kubectl delete pod load-generator --ignore-not-found > /dev/null

echo
echo "🚀 Starting new 'load-generator' pod to stress /api/sum endpoint with random numbers..."
echo "💡 Sending continuous POST requests like: { num1: X, num2: Y }"
echo "📡 Target: http://backend-service:8080/api/sum"

CMD='while true; do n1=$((RANDOM % 100)); n2=$((RANDOM % 100)); echo "POSTing {\"num1\": $n1, \"num2\": $n2}..."; wget -q --post-data="{\"num1\":$n1,\"num2\":$n2}" --header="Content-Type: application/json" -O- http://backend-service:8080/api/sum; sleep 0.5; done'

kubectl run load-generator --image=busybox --restart=Never -- /bin/sh -c "$CMD"

echo
echo "✅ Pod started. Use 'kubectl logs load-generator -f' to view live traffic."
echo "🛑 Run 'kubectl delete pod load-generator' to stop it."
