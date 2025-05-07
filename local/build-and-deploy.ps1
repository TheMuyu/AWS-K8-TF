# Point Docker CLI to Minikube's Docker daemon
& minikube -p minikube docker-env | Invoke-Expression

Write-Host "`n🔧 Building Docker images inside Minikube..." -ForegroundColor Cyan

# Build backend image
docker build -t local-backend ..\backend\SumApi

# Build frontend image
docker build -t local-frontend ..\frontend\sum-app

Write-Host "`n✅ Images built successfully." -ForegroundColor Green

# Enable ingress (safe to rerun even if already enabled)
Write-Host "`n⚙️ Enabling Minikube ingress addon (if not already enabled)..." -ForegroundColor Cyan
minikube addons enable ingress

# Apply Kubernetes manifests
Write-Host "`n📦 Applying Kubernetes deployments..." -ForegroundColor Cyan
kubectl apply -f .\k8s

# Force rollout restart (ensures new local image is used)
Write-Host "`n🔄 Forcing deployment rollouts..." -ForegroundColor Cyan
kubectl rollout restart deployment frontend
kubectl rollout restart deployment backend

Write-Host "`n🚀 Deployment complete and restarted." -ForegroundColor Green
