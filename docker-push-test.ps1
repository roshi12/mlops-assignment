# Quick Docker Test and Push Script
Write-Host "=== Docker Setup for bilalrazaswe/focus-meditation-agent ===" -ForegroundColor Green

# Test Docker
Write-Host "1. Testing Docker..." -ForegroundColor Yellow
docker --version

# Build image with your repo name
Write-Host "2. Building Docker image..." -ForegroundColor Yellow
docker build -t bilalrazaswe/focus-meditation-agent:latest .
docker build -t bilalrazaswe/focus-meditation-agent:v1.0 .

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Docker build successful!" -ForegroundColor Green
    
    # Login to Docker Hub
    Write-Host "3. Login to Docker Hub..." -ForegroundColor Yellow
    Write-Host "You'll need to enter your Docker Hub credentials:" -ForegroundColor Cyan
    docker login
    
    # Push both tags
    Write-Host "4. Pushing to Docker Hub..." -ForegroundColor Yellow
    docker push bilalrazaswe/focus-meditation-agent:latest
    docker push bilalrazaswe/focus-meditation-agent:v1.0
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "🎉 SUCCESS! Image pushed to Docker Hub" -ForegroundColor Green
        Write-Host "🌐 View at: https://hub.docker.com/r/bilalrazaswe/focus-meditation-agent" -ForegroundColor Blue
        
        # Test the image
        Write-Host "5. Testing the image..." -ForegroundColor Yellow
        $containerId = docker run -d -p 5001:5000 bilalrazaswe/focus-meditation-agent:latest
        Start-Sleep 5
        
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:5001/health" -UseBasicParsing -TimeoutSec 5
            Write-Host "✅ Container is working! Health check passed" -ForegroundColor Green
            Write-Host "Response: $($response.Content)" -ForegroundColor Cyan
        } catch {
            Write-Host "⚠️  Container test failed, but image was pushed successfully" -ForegroundColor Yellow
        } finally {
            docker stop $containerId | Out-Null
            docker rm $containerId | Out-Null
        }
    }
} else {
    Write-Host "❌ Docker build failed. Check Docker Desktop is running." -ForegroundColor Red
}

Write-Host "`n=== Next Steps ===" -ForegroundColor Green
Write-Host "1. Commit and push your changes to trigger GitHub Actions" -ForegroundColor Cyan  
Write-Host "2. Create PR from dev → test → master to test full pipeline" -ForegroundColor Cyan
Write-Host "3. Show teacher the Docker Hub repository with your image" -ForegroundColor Cyan