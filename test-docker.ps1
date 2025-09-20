# PowerShell script to test Docker build locally
Write-Host "Testing Docker build for Focus Meditation Agent..." -ForegroundColor Green

# Build the Docker image
Write-Host "Building Docker image..." -ForegroundColor Yellow
docker build -t focus-meditation-agent:test .

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Docker build successful!" -ForegroundColor Green
    
    # Run the container briefly to test it
    Write-Host "Testing container startup..." -ForegroundColor Yellow
    $containerId = docker run -d -p 5001:5000 focus-meditation-agent:test
    
    # Wait a moment for startup
    Start-Sleep 3
    
    # Test the health endpoint
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:5001/health" -UseBasicParsing
        Write-Host "✅ Health check successful!" -ForegroundColor Green
        Write-Host "Response: $($response.Content)" -ForegroundColor Cyan
    } catch {
        Write-Host "❌ Health check failed: $_" -ForegroundColor Red
    }
    
    # Clean up
    docker stop $containerId | Out-Null
    docker rm $containerId | Out-Null
    Write-Host "✅ Container test completed and cleaned up" -ForegroundColor Green
    
} else {
    Write-Host "❌ Docker build failed!" -ForegroundColor Red
}