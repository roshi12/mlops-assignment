# Kubernetes Deployment Script for Focus Meditation Agent
# This script deploys the application to a Kubernetes cluster

Write-Host "=== Kubernetes Deployment Script ===" -ForegroundColor Cyan
Write-Host ""

# Configuration
$NAMESPACE = "default"
$K8S_DIR = "k8s"

# Step 1: Check if kubectl is available
Write-Host "Step 1: Checking kubectl installation..." -ForegroundColor Yellow
kubectl version --client
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: kubectl is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install kubectl: https://kubernetes.io/docs/tasks/tools/" -ForegroundColor Yellow
    exit 1
}
Write-Host "kubectl is available!" -ForegroundColor Green
Write-Host ""

# Step 2: Check cluster connection
Write-Host "Step 2: Checking Kubernetes cluster connection..." -ForegroundColor Yellow
kubectl cluster-info
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Cannot connect to Kubernetes cluster" -ForegroundColor Red
    Write-Host "Please ensure your cluster is running and kubeconfig is configured" -ForegroundColor Yellow
    exit 1
}
Write-Host "Connected to cluster!" -ForegroundColor Green
Write-Host ""

# Step 3: Apply Deployment
Write-Host "Step 3: Deploying application..." -ForegroundColor Yellow
kubectl apply -f $K8S_DIR/deployment.yaml -n $NAMESPACE
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Deployment failed!" -ForegroundColor Red
    exit 1
}
Write-Host "Deployment created successfully!" -ForegroundColor Green
Write-Host ""

# Step 4: Apply Service (LoadBalancer)
Write-Host "Step 4: Creating service..." -ForegroundColor Yellow
Write-Host "Choose service type:" -ForegroundColor Cyan
Write-Host "1. LoadBalancer (recommended for cloud environments)" -ForegroundColor White
Write-Host "2. NodePort (for local clusters like Minikube/Docker Desktop)" -ForegroundColor White
$choice = Read-Host "Enter choice (1 or 2)"

if ($choice -eq "2") {
    kubectl apply -f $K8S_DIR/service-nodeport.yaml -n $NAMESPACE
    $SERVICE_FILE = "service-nodeport.yaml"
} else {
    kubectl apply -f $K8S_DIR/service.yaml -n $NAMESPACE
    $SERVICE_FILE = "service.yaml"
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Service creation failed!" -ForegroundColor Red
    exit 1
}
Write-Host "Service created successfully!" -ForegroundColor Green
Write-Host ""

# Step 5: Wait for deployment to be ready
Write-Host "Step 5: Waiting for deployment to be ready..." -ForegroundColor Yellow
kubectl rollout status deployment/focus-meditation-agent -n $NAMESPACE --timeout=300s
Write-Host ""

# Step 6: Display deployment status
Write-Host "Step 6: Deployment Status" -ForegroundColor Yellow
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Pods:" -ForegroundColor Cyan
kubectl get pods -n $NAMESPACE -l app=focus-meditation-agent
Write-Host ""
Write-Host "Deployment:" -ForegroundColor Cyan
kubectl get deployment focus-meditation-agent -n $NAMESPACE
Write-Host ""
Write-Host "Service:" -ForegroundColor Cyan
kubectl get service -n $NAMESPACE -l app=focus-meditation-agent
Write-Host ""

# Step 7: Get access information
Write-Host "Step 7: Access Information" -ForegroundColor Yellow
Write-Host "==================================" -ForegroundColor Cyan
if ($choice -eq "2") {
    Write-Host "Service Type: NodePort" -ForegroundColor Green
    Write-Host "Access the application using:" -ForegroundColor Yellow
    Write-Host "  For Minikube: minikube service focus-meditation-agent-nodeport" -ForegroundColor White
    Write-Host "  For Docker Desktop: http://localhost:30080" -ForegroundColor White
} else {
    Write-Host "Service Type: LoadBalancer" -ForegroundColor Green
    Write-Host "Getting external IP (this may take a few minutes)..." -ForegroundColor Yellow
    $EXTERNAL_IP = kubectl get service focus-meditation-agent -n $NAMESPACE -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
    if ($EXTERNAL_IP) {
        Write-Host "Access the application at: http://$EXTERNAL_IP" -ForegroundColor White
    } else {
        Write-Host "External IP pending... Run this command to check:" -ForegroundColor Yellow
        Write-Host "kubectl get service focus-meditation-agent -n $NAMESPACE" -ForegroundColor White
    }
}
Write-Host ""

Write-Host "=== DEPLOYMENT SUCCESSFUL ===" -ForegroundColor Green
Write-Host ""
Write-Host "Useful commands:" -ForegroundColor Yellow
Write-Host "  View logs: kubectl logs -l app=focus-meditation-agent -n $NAMESPACE" -ForegroundColor White
Write-Host "  View pods: kubectl get pods -n $NAMESPACE -l app=focus-meditation-agent" -ForegroundColor White
Write-Host "  Scale deployment: kubectl scale deployment focus-meditation-agent --replicas=5 -n $NAMESPACE" -ForegroundColor White
Write-Host "  Delete deployment: kubectl delete -f $K8S_DIR/ -n $NAMESPACE" -ForegroundColor White
