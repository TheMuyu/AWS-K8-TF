Write-Host "🔄 Deleting any existing 'load-generator' pod..."
kubectl delete pod load-generator --ignore-not-found | Out-Null

Write-Host "`n🚀 Starting new 'load-generator' pod to stress /api/sum endpoint with random numbers..."
Write-Host "💡 This will send continuous POST requests like: { num1: X, num2: Y }"
Write-Host "📡 Target: http://backend-service:8080/api/sum"

kubectl run load-generator --image=busybox --restart=Never -- /bin/sh -c @'
while true; do
  n1=$((RANDOM % 100))
  n2=$((RANDOM % 100))
  echo "POSTing {\"num1\": $n1, \"num2\": $n2}..."
  wget -q --post-data='{"num1":'$n1',"num2":'$n2'}' \
       --header='Content-Type: application/json' \
       -O- http://backend-service:8080/api/sum
  sleep 0.5
done
'@

Write-Host "`n✅ Pod started. Use 'kubectl logs load-generator -f' to view real-time output."
Write-Host "🛑 Run 'kubectl delete pod load-generator' to stop the load test."
