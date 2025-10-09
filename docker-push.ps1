# Script to build and push Docker image to Docker Hub
# Make sure Docker Desktop is running before executing this script

Write-Host "=== Docker Hub Push Script ===" -ForegroundColor Cyan
Write-Host ""

# Configuration
$DOCKER_USERNAME = "bilalrazaswe"
$IMAGE_NAME = "focus-meditation-agent"
$TAG = "latest"
$FULL_IMAGE_NAME = "${DOCKER_USERNAME}/${IMAGE_NAME}:${TAG}"

# Step 1: Check if Docker is running
Write-Host "Step 1: Checking Docker status..." -ForegroundColor Yellow
docker --version
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker is not running. Please start Docker Desktop and try again." -ForegroundColor Red
    exit 1
}
Write-Host "Docker is running!" -ForegroundColor Green
Write-Host ""

# Step 2: Build the Docker image
Write-Host "Step 2: Building Docker image..." -ForegroundColor Yellow
Write-Host "Image: $FULL_IMAGE_NAME" -ForegroundColor Cyan
docker build -t $FULL_IMAGE_NAME .
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker build failed!" -ForegroundColor Red
    exit 1
}
Write-Host "Docker image built successfully!" -ForegroundColor Green
Write-Host ""

# Step 3: Login to Docker Hub (if not already logged in)
Write-Host "Step 3: Docker Hub Login" -ForegroundColor Yellow
Write-Host "Please login to Docker Hub with username: $DOCKER_USERNAME" -ForegroundColor Cyan
docker login
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker login failed!" -ForegroundColor Red
    exit 1
}
Write-Host "Login successful!" -ForegroundColor Green
Write-Host ""

# Step 4: Push the image to Docker Hub
Write-Host "Step 4: Pushing image to Docker Hub..." -ForegroundColor Yellow
docker push $FULL_IMAGE_NAME
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker push failed!" -ForegroundColor Red
    exit 1
}
Write-Host "Docker image pushed successfully!" -ForegroundColor Green
Write-Host ""

# Step 5: Verify the image
Write-Host "Step 5: Verifying local image..." -ForegroundColor Yellow
docker images | Select-String $IMAGE_NAME
Write-Host ""

Write-Host "=== SUCCESS ===" -ForegroundColor Green
Write-Host "Docker image is now available at: https://hub.docker.com/r/$DOCKER_USERNAME/$IMAGE_NAME" -ForegroundColor Cyan
Write-Host ""
Write-Host "You can pull this image using:" -ForegroundColor Yellow
Write-Host "docker pull $FULL_IMAGE_NAME" -ForegroundColor White
