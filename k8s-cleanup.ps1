# Kubernetes Cleanup Script for Focus Meditation Agent
# This script removes all Kubernetes resources for the application

Write-Host "=== Kubernetes Cleanup Script ===" -ForegroundColor Cyan
Write-Host ""

# Configuration
$NAMESPACE = "default"
$K8S_DIR = "k8s"

# Confirmation prompt
Write-Host "WARNING: This will delete all Kubernetes resources for Focus Meditation Agent" -ForegroundColor Red
$confirm = Read-Host "Are you sure you want to continue? (yes/no)"

if ($confirm -ne "yes") {
    Write-Host "Cleanup cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Deleting Kubernetes resources..." -ForegroundColor Yellow

# Delete all resources in the k8s directory
kubectl delete -f $K8S_DIR/ -n $NAMESPACE

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "=== CLEANUP SUCCESSFUL ===" -ForegroundColor Green
    Write-Host "All resources have been removed from the cluster." -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "=== CLEANUP FAILED ===" -ForegroundColor Red
    Write-Host "Some resources may still exist. Check manually with:" -ForegroundColor Yellow
    Write-Host "kubectl get all -l app=focus-meditation-agent -n $NAMESPACE" -ForegroundColor White
}

Write-Host ""
