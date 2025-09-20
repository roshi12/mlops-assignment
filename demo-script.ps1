# MLOps Assignment Demonstration Script
# Run this to show complete CI/CD pipeline to your teacher

Write-Host "=== MLOps Assignment Demonstration ===" -ForegroundColor Green
Write-Host "Student: [Your Name] | Group: 01" -ForegroundColor Cyan
Write-Host ""

# 1. Show project structure
Write-Host "1. Project Structure:" -ForegroundColor Yellow
tree /F

Write-Host "`n2. Testing Flask Application:" -ForegroundColor Yellow
python app.py &
Start-Sleep 3

# Test endpoints
Write-Host "Testing API endpoints..." -ForegroundColor Cyan
try {
    $health = Invoke-RestMethod -Uri "http://localhost:5000/health"
    Write-Host "✅ Health Check: $($health.status)" -ForegroundColor Green
    
    $stats = Invoke-RestMethod -Uri "http://localhost:5000/stats" 
    Write-Host "✅ Stats: $($stats.total_sessions) sessions" -ForegroundColor Green
} catch {
    Write-Host "❌ API Test Failed: $_" -ForegroundColor Red
}

# Stop Flask app
Get-Process | Where-Object {$_.ProcessName -eq "python"} | Stop-Process -Force

Write-Host "`n3. Docker Build & Push:" -ForegroundColor Yellow
Write-Host "Building Docker image..." -ForegroundColor Cyan
docker build -t bilalrazaswe/focus-meditation-agent:latest .

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Docker build successful" -ForegroundColor Green
    
    Write-Host "Pushing to Docker Hub..." -ForegroundColor Cyan
    docker push bilalrazaswe/focus-meditation-agent:latest
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Docker push successful" -ForegroundColor Green
        Write-Host "🌐 Image available at: https://hub.docker.com/r/bilalrazaswe/focus-meditation-agent" -ForegroundColor Blue
    }
}

Write-Host "`n4. Git Workflow:" -ForegroundColor Yellow  
Write-Host "Current branch:" -ForegroundColor Cyan
git branch --show-current
Write-Host "Recent commits:" -ForegroundColor Cyan
git log --oneline -5

Write-Host "`n5. GitHub Actions:" -ForegroundColor Yellow
Write-Host "🌐 Check workflows at: https://github.com/roshi12/mlops-assignment/actions" -ForegroundColor Blue

Write-Host "`n=== Demonstration Complete ===" -ForegroundColor Green