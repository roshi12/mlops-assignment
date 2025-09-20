# Deployment and Demo Guide

## Complete Setup and Demonstration Guide for Teachers

### Overview

This guide provides step-by-step instructions for setting up, deploying, and demonstrating the Focus Meditation Agent MLOps pipeline. Perfect for teacher evaluation and assignment demonstration.

---

## Prerequisites

### System Requirements

**Required Software**:
- Windows 10/11 (current setup)
- Python 3.11 or higher
- Docker Desktop for Windows
- Git for Windows
- Web browser (Chrome/Firefox recommended)

**Optional Software** (for complete pipeline):
- Java 8+ (for Jenkins)
- PowerShell 5.1+ (pre-installed on Windows)

**Hardware Requirements**:
- RAM: 8GB minimum, 16GB recommended
- Storage: 5GB free space
- Network: Internet connection for Docker Hub and GitHub

---

## Quick Start (5-minute demo)

### Option A: Docker-only Demo

**Perfect for quick demonstration**

```powershell
# 1. Clone repository
git clone https://github.com/roshi12/mlops-assignment.git
cd mlops-assignment

# 2. Start Docker Desktop (wait for it to start completely)

# 3. Build and run container
docker build -t bilalrazaswe/focus-meditation-agent:demo .
docker run -p 5000:5000 bilalrazaswe/focus-meditation-agent:demo

# 4. Test API in another terminal
curl http://localhost:5000/health
curl http://localhost:5000/sessions
curl http://localhost:5000/stats
```

### Option B: Local Python Demo

**Perfect if Docker has issues**

```powershell
# 1. Clone and setup
git clone https://github.com/roshi12/mlops-assignment.git
cd mlops-assignment

# 2. Create virtual environment
python -m venv .venv
.\.venv\Scripts\Activate.ps1

# 3. Install dependencies
pip install -r requirements.txt

# 4. Run application
python app.py

# 5. Test endpoints (in browser or curl)
# http://localhost:5000/health
# http://localhost:5000/sessions
# http://localhost:5000/stats
```

---

## Complete Setup Guide

### Step 1: Environment Setup

#### 1.1 Install Docker Desktop

1. Download Docker Desktop from [docker.com](https://www.docker.com/products/docker-desktop)
2. Run installer with default settings
3. Restart computer if required
4. Launch Docker Desktop
5. Wait for "Docker Desktop is running" message in system tray

**Verification**:
```powershell
docker --version
docker run hello-world
```

#### 1.2 Setup Python Environment

```powershell
# Check Python version
python --version  # Should be 3.11+

# Clone repository
git clone https://github.com/roshi12/mlops-assignment.git
cd mlops-assignment

# Create virtual environment
python -m venv .venv

# Activate environment (Windows)
.\.venv\Scripts\Activate.ps1

# Install dependencies
pip install -r requirements.txt
```

### Step 2: Local Development Testing

#### 2.1 Run Flask Application

```powershell
# Start Flask app
python app.py

# Should display:
# * Running on http://127.0.0.1:5000
# * Debug mode: off
```

#### 2.2 Test API Endpoints

**Using curl**:
```bash
# Health check
curl http://localhost:5000/health

# Get sessions
curl http://localhost:5000/sessions

# Get statistics
curl http://localhost:5000/stats

# Make prediction
curl -X POST http://localhost:5000/predict \
  -H "Content-Type: application/json" \
  -d '{"duration_minutes": 20, "mood_before": "stressed"}'
```

**Using browser**:
- Navigate to: http://localhost:5000/health
- Navigate to: http://localhost:5000/sessions
- Navigate to: http://localhost:5000/stats

#### 2.3 Run Tests

```powershell
# Run unit tests
python -m pytest tests/ -v

# Run code quality checks
python -m flake8 .

# Expected output: All tests should pass
```

### Step 3: Docker Containerization

#### 3.1 Build Docker Image

```powershell
# Build image with your Docker Hub repository name
docker build -t bilalrazaswe/focus-meditation-agent:latest .

# Verify image was created
docker images | findstr focus-meditation
```

#### 3.2 Test Container Locally

```powershell
# Run container
docker run -d -p 5001:5000 --name focus-test bilalrazaswe/focus-meditation-agent:latest

# Wait 5 seconds for startup
Start-Sleep 5

# Test container
curl http://localhost:5001/health

# Check logs
docker logs focus-test

# Stop and remove container
docker stop focus-test
docker rm focus-test
```

#### 3.3 Push to Docker Hub

```powershell
# Login to Docker Hub
docker login

# Push image
docker push bilalrazaswe/focus-meditation-agent:latest

# Verify on Docker Hub web interface
# Visit: https://hub.docker.com/r/bilalrazaswe/focus-meditation-agent
```

### Step 4: CI/CD Pipeline Testing

#### 4.1 GitHub Actions Testing

**Trigger lint workflow**:
```powershell
# Make a small change
echo "# Test comment" >> README.md

# Commit and push to dev branch
git add .
git commit -m "Test CI/CD pipeline"
git push origin dev
```

**Check results**:
- Visit: https://github.com/roshi12/mlops-assignment/actions
- Should see "Lint (flake8)" workflow running/completed

#### 4.2 Pull Request Testing

**Test dev → test workflow**:
1. Go to: https://github.com/roshi12/mlops-assignment/compare/test...dev
2. Click "Create pull request"
3. Add title: "Test pipeline integration"
4. Create pull request
5. Should trigger "Unit Tests" workflow

**Test test → master workflow**:
1. Merge the test branch PR
2. Go to: https://github.com/roshi12/mlops-assignment/compare/master...test
3. Create pull request to master
4. Should trigger Jenkins pipeline (if configured)

### Step 5: Jenkins Setup (Optional)

#### 5.1 Quick Jenkins with Docker

```powershell
# Run Jenkins in Docker
docker run -d -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  --name jenkins-demo \
  jenkins/jenkins:lts

# Get initial admin password
docker exec jenkins-demo cat /var/jenkins_home/secrets/initialAdminPassword

# Open Jenkins: http://localhost:8080
```

#### 5.2 Jenkins Configuration

1. **Initial Setup**:
   - Open http://localhost:8080
   - Enter admin password from previous step
   - Install suggested plugins
   - Create admin user

2. **Configure Pipeline**:
   - New Item → Pipeline
   - Name: "focus-meditation-agent"
   - Pipeline script from SCM
   - Git repository: https://github.com/roshi12/mlops-assignment.git
   - Branch: master
   - Script path: Jenkinsfile

3. **Add Docker Hub Credentials**:
   - Manage Jenkins → Manage Credentials
   - Add Username/Password credential
   - ID: `dockerhub-creds`
   - Username: your Docker Hub username
   - Password: your Docker Hub password

---

## Demonstration Scripts

### Auto Demo Script

**Use the provided demo script**:
```powershell
# Run comprehensive demonstration
powershell -ExecutionPolicy Bypass -File demo-script.ps1
```

### Manual Demo Script

```powershell
Write-Host "=== MLOps Pipeline Demonstration ===" -ForegroundColor Green

# 1. Show project structure
Write-Host "1. Project Structure:" -ForegroundColor Yellow
tree /F

# 2. Show Git workflow
Write-Host "2. Git Workflow:" -ForegroundColor Yellow
git branch -a
git log --oneline -5

# 3. Test local application
Write-Host "3. Local Application Test:" -ForegroundColor Yellow
python app.py &
Start-Sleep 3
curl http://localhost:5000/health
Get-Process -Name python | Stop-Process -Force

# 4. Docker build and test
Write-Host "4. Docker Integration:" -ForegroundColor Yellow
docker build -t focus-demo .
docker run -d -p 5001:5000 --name demo focus-demo
Start-Sleep 3
curl http://localhost:5001/health
docker stop demo
docker rm demo

# 5. Show online resources
Write-Host "5. Online Resources:" -ForegroundColor Yellow
Write-Host "GitHub: https://github.com/roshi12/mlops-assignment" -ForegroundColor Cyan
Write-Host "Docker Hub: https://hub.docker.com/r/bilalrazaswe/focus-meditation-agent" -ForegroundColor Cyan
Write-Host "Actions: https://github.com/roshi12/mlops-assignment/actions" -ForegroundColor Cyan
```

---

## Teacher Evaluation Checklist

### ✅ Assignment Requirements Verification

**Core Components**:
- [ ] **Unique Dataset**: Check `data/group_01/meditation_sessions.csv`
- [ ] **ML Model**: Verify `model/model.pkl` and training script
- [ ] **Flask Application**: Test all 4 API endpoints
- [ ] **Docker Integration**: Build and run container successfully
- [ ] **CI/CD Pipeline**: GitHub Actions workflows functional
- [ ] **Branch Strategy**: dev → test → master workflow
- [ ] **Admin Approval**: CODEOWNERS file configured
- [ ] **Code Quality**: flake8 linting passes
- [ ] **Unit Testing**: pytest tests pass
- [ ] **Jenkins Pipeline**: Jenkinsfile configured correctly
- [ ] **Email Notifications**: Jenkins email setup

### 🎯 Demonstration Points

**Technical Excellence** (Show these):
1. **Code Quality**: Run `flake8 .` - should show no errors
2. **Test Coverage**: Run `pytest tests/ -v` - all tests pass
3. **Documentation**: Comprehensive README and API docs
4. **Container Security**: Multi-stage Docker build
5. **Pipeline Automation**: GitHub Actions integration
6. **Production Ready**: Gunicorn WSGI server configuration

**MLOps Best Practices**:
1. **Version Control**: Proper Git workflow
2. **Automated Testing**: CI/CD pipeline integration
3. **Containerization**: Docker best practices
4. **Monitoring**: Health check endpoints
5. **Documentation**: Complete technical documentation
6. **Security**: Credential management in CI/CD

---

## Troubleshooting Guide

### Common Issues and Solutions

**Docker Desktop Won't Start**:
```powershell
# Restart Docker Desktop
# Or run: wsl --shutdown (if using WSL2)
```

**Port Already in Use**:
```powershell
# Find process using port 5000
netstat -ano | findstr :5000

# Kill process (replace PID)
taskkill /PID 1234 /F
```

**Python Module Not Found**:
```powershell
# Ensure virtual environment is activated
.\.venv\Scripts\Activate.ps1

# Reinstall requirements
pip install -r requirements.txt
```

**GitHub Actions Not Triggering**:
- Check branch names match workflow triggers
- Verify workflow files are in `.github/workflows/`
- Check repository permissions and settings

**Jenkins Pipeline Fails**:
- Verify Docker Hub credentials are configured
- Check Jenkins logs for specific error messages
- Ensure Jenkinsfile syntax is correct

---

## Performance Benchmarks

### Expected Performance Metrics

**API Response Times**:
- Health check: < 50ms
- Sessions endpoint: < 100ms
- Statistics endpoint: < 150ms
- Prediction endpoint: < 200ms

**Container Metrics**:
- Build time: < 3 minutes
- Startup time: < 10 seconds
- Memory usage: < 256MB
- CPU usage: < 20% idle

**Pipeline Metrics**:
- GitHub Actions (lint): < 2 minutes
- GitHub Actions (test): < 3 minutes
- Jenkins build: < 5 minutes
- Docker push: < 2 minutes

---

## Submission Package

### Files to Submit

**Core Files** (ZIP the entire repository):
```
mlops-assignment/
├── Source code (all files)
├── Documentation (docs/ folder)
├── Screenshots of GitHub Actions
├── Screenshots of Docker Hub
├── Screenshots of Jenkins (if available)
└── Demo video (2-3 minutes)
```

**Evidence Package**:
1. **GitHub Repository Link**
2. **Docker Hub Repository Link**
3. **Screenshots showing**:
   - GitHub Actions workflows completed
   - Docker Hub with pushed images
   - Jenkins pipeline execution
   - API endpoints working
4. **Demo Video** showing complete workflow
5. **Written Report** (SUBMISSION_REPORT.md)

---

**Guide Version**: 1.0  
**Last Updated**: September 20, 2025  
**Tested On**: Windows 11, Docker Desktop 4.0+  
**Status**: Production Ready