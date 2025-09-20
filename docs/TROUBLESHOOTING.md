# Troubleshooting Guide & FAQ

## Common Issues and Solutions

### Docker Issues

#### Docker Desktop Won't Start

**Symptoms**:
- "Docker Desktop is unable to start" error
- Commands fail with "Docker daemon not running"

**Solutions**:
```powershell
# Method 1: Restart Docker Desktop
# Close Docker Desktop completely
# Start as Administrator
# Wait for complete startup (2-3 minutes)

# Method 2: Reset Docker Desktop
# Docker Desktop → Troubleshoot → Reset to factory defaults

# Method 3: WSL2 Reset (if using WSL2 backend)
wsl --shutdown
wsl --unregister docker-desktop
wsl --unregister docker-desktop-data
# Restart Docker Desktop

# Method 4: Check Windows Features
# Enable: Windows Subsystem for Linux
# Enable: Virtual Machine Platform
# Restart computer
```

#### Docker Build Fails

**Symptoms**:
- "failed to build" errors
- Package installation failures

**Solutions**:
```powershell
# Clear Docker cache
docker system prune -a

# Check Dockerfile syntax
# Ensure no Windows line endings (use Unix LF)

# Build with no cache
docker build --no-cache -t bilalrazaswe/focus-meditation-agent:latest .

# Check available disk space (need 5GB+)
docker system df
```

#### Container Won't Start

**Symptoms**:
- Container exits immediately
- Port binding errors

**Solutions**:
```powershell
# Check container logs
docker logs <container-name>

# Check if port is in use
netstat -ano | findstr :5000

# Kill process using port
taskkill /PID <process-id> /F

# Run container with different port
docker run -p 5001:5000 bilalrazaswe/focus-meditation-agent:latest
```

---

### Python Environment Issues

#### Module Not Found Errors

**Symptoms**:
- "ModuleNotFoundError: No module named 'flask'"
- Import errors when running application

**Solutions**:
```powershell
# Ensure virtual environment is activated
.\.venv\Scripts\Activate.ps1

# Verify activation (should show (.venv))
# Command prompt should show: (.venv) PS C:\path>

# Reinstall requirements
pip install --upgrade pip
pip install -r requirements.txt

# Check installed packages
pip list

# If still failing, recreate environment
deactivate
Remove-Item .venv -Recurse -Force
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

#### Python Version Issues

**Symptoms**:
- "Python was not found" error
- Version compatibility warnings

**Solutions**:
```powershell
# Check Python version
python --version

# If not 3.11+, install from python.org
# Add Python to PATH during installation

# Use specific Python version
py -3.11 -m venv .venv

# Check available Python versions
py --list
```

#### Permission Errors

**Symptoms**:
- Access denied when creating virtual environment
- Permission errors during pip install

**Solutions**:
```powershell
# Run PowerShell as Administrator

# Set execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Alternative: bypass execution policy for single script
powershell -ExecutionPolicy Bypass -File script.ps1
```

---

### GitHub Actions Issues

#### Workflows Not Triggering

**Symptoms**:
- No workflows appear in Actions tab
- Push to branch doesn't trigger workflow

**Solutions**:
```yaml
# Check workflow file location
# Must be in: .github/workflows/

# Check YAML syntax
# Use online YAML validator

# Check branch names in workflow
on:
  push:
    branches: [dev]  # Ensure 'dev' matches your branch name

# Check if workflows are disabled
# Go to repository Settings → Actions
# Ensure "Actions permissions" allows workflows
```

#### Workflow Fails on Dependencies

**Symptoms**:
- flake8 not found errors
- pytest command not found

**Solutions**:
```yaml
# Ensure all dependencies are installed in workflow
- run: |
    python -m pip install --upgrade pip
    pip install -r requirements.txt
    pip install flake8 pytest

# Check requirements.txt includes all test dependencies
# Add to requirements.txt:
# flake8>=5.0.0
# pytest>=7.0.0
```

#### Flake8 Errors Failing Pipeline

**Symptoms**:
- Pipeline fails with style errors
- PEP8 compliance issues

**Solutions**:
```powershell
# Run flake8 locally first
python -m flake8 .

# Fix common issues:
# - Line too long (max 79 characters)
# - Missing blank lines around functions
# - Unused imports
# - Trailing whitespace

# Create .flake8 config file to ignore certain errors
echo "[flake8]" > .flake8
echo "max-line-length = 88" >> .flake8
echo "ignore = E203,W503" >> .flake8
```

---

### Jenkins Issues

#### Jenkins Won't Start

**Symptoms**:
- Cannot access http://localhost:8080
- Connection refused errors

**Solutions**:
```powershell
# If using Docker Jenkins
docker ps -a | findstr jenkins

# Check if container is running
docker logs jenkins-demo

# Restart Jenkins container
docker restart jenkins-demo

# If using WAR file
# Check if Java is installed
java -version

# Start Jenkins with explicit port
java -jar jenkins.war --httpPort=8080
```

#### Pipeline Fails - Docker Commands

**Symptoms**:
- "docker command not found" in Jenkins
- Permission denied for Docker socket

**Solutions**:
```groovy
// In Jenkinsfile, use Docker-in-Docker or Docker socket mounting
pipeline {
    agent {
        docker {
            image 'docker:latest'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    // ... rest of pipeline
}

// Or install Docker in Jenkins agent
// Jenkins → Manage Jenkins → Global Tool Configuration
// Add Docker installation
```

#### Docker Hub Push Fails

**Symptoms**:
- Authentication failures
- "repository does not exist" errors

**Solutions**:
```powershell
# Verify credentials in Jenkins
# Manage Jenkins → Manage Credentials
# Ensure 'dockerhub-creds' exists with correct username/password

# Test Docker Hub login manually
docker login

# Ensure repository exists on Docker Hub
# Visit: https://hub.docker.com/r/bilalrazaswe/focus-meditation-agent
# Create repository if it doesn't exist

# Check image naming in Jenkinsfile
DOCKERHUB_REPO = "bilalrazaswe/focus-meditation-agent"  // Must match exactly
```

---

### Application Runtime Issues

#### Flask App Won't Start

**Symptoms**:
- "Address already in use" errors
- Flask import errors

**Solutions**:
```powershell
# Check if port 5000 is in use
netstat -ano | findstr :5000

# Kill process using port
Get-Process -Id (Get-NetTCPConnection -LocalPort 5000).OwningProcess | Stop-Process -Force

# Start Flask on different port
$env:FLASK_RUN_PORT="5001"
python app.py

# Check Flask installation
python -c "import flask; print(flask.__version__)"
```

#### Model Loading Errors

**Symptoms**:
- "model not loaded" error from /predict endpoint
- Model file not found errors

**Solutions**:
```powershell
# Check if model file exists
ls model/model.pkl

# Retrain model if missing
python model/train.py

# Check model file permissions
# Ensure model.pkl is readable

# Verify model format
python -c "import joblib; model = joblib.load('model/model.pkl'); print(type(model))"
```

#### Dataset Loading Issues

**Symptoms**:
- Empty dataset responses
- CSV parsing errors

**Solutions**:
```powershell
# Check if dataset exists
ls data/group_01/meditation_sessions.csv

# Verify CSV format
Get-Content data/group_01/meditation_sessions.csv -TotalCount 5

# Check file encoding (should be UTF-8)
# If corrupted, recreate from backup or template

# Verify pandas can read file
python -c "import pandas as pd; df = pd.read_csv('data/group_01/meditation_sessions.csv'); print(df.head())"
```

---

### Network and Connectivity Issues

#### API Endpoints Not Accessible

**Symptoms**:
- Connection refused to localhost:5000
- Timeout errors

**Solutions**:
```powershell
# Check if Flask is running
Get-Process -Name python

# Verify Flask is listening on correct port
netstat -ano | findstr :5000

# Check Windows Firewall
# Allow Python through Windows Defender Firewall

# Try different IP binding
# In app.py: app.run(host="0.0.0.0", port=5000)

# Test with different tools
curl http://localhost:5000/health
Invoke-WebRequest -Uri http://localhost:5000/health
```

#### Docker Container Network Issues

**Symptoms**:
- Cannot access container from host
- Container cannot reach external services

**Solutions**:
```powershell
# Check container port mapping
docker port <container-name>

# Inspect container network
docker inspect <container-name> | findstr IPAddress

# Test container internal network
docker exec -it <container-name> curl http://localhost:5000/health

# Check Docker network configuration
docker network ls
docker network inspect bridge
```

---

### Performance Issues

#### Slow Application Response

**Symptoms**:
- API endpoints taking > 5 seconds
- High CPU/memory usage

**Solutions**:
```powershell
# Monitor system resources
Get-Process -Name python | Select-Object Name,CPU,WorkingSet

# Check Docker container resources
docker stats

# Profile Flask application
# Add timing logs to app.py
import time
start_time = time.time()
# ... endpoint logic
print(f"Endpoint took {time.time() - start_time} seconds")

# Optimize model loading (cache in memory)
# Optimize DataFrame operations
```

#### Docker Build Taking Too Long

**Symptoms**:
- Build process > 10 minutes
- Frequent re-downloading of packages

**Solutions**:
```dockerfile
# Optimize Dockerfile layer caching
# Copy requirements.txt first, then install packages
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .

# Use smaller base image
FROM python:3.11-slim instead of python:3.11

# Use multi-stage builds (already implemented)

# Clear Docker build cache if needed
docker builder prune
```

---

## Frequently Asked Questions

### General Questions

**Q: What Python version is required?**
A: Python 3.11 or higher. The application uses features available in Python 3.11+.

**Q: Can I run this on macOS/Linux?**
A: Yes, with minor modifications to scripts. Replace PowerShell commands with bash equivalents.

**Q: Do I need Docker Desktop for the assignment?**
A: Docker is required for containerization demonstration. Docker Desktop is the easiest option for Windows.

### Assignment-Specific Questions

**Q: How do I prove the pipeline is working?**
A: Show GitHub Actions workflows, Docker Hub images, and working API endpoints. Screenshots are sufficient.

**Q: What if Jenkins won't work on my computer?**
A: Focus on GitHub Actions workflows and Docker containerization. These cover most requirements.

**Q: How do I demonstrate the unique dataset?**
A: Show the `data/group_01/meditation_sessions.csv` file and the `/sessions` API endpoint.

**Q: What if my Docker Hub push fails?**
A: Ensure you're logged in (`docker login`) and the repository exists on Docker Hub.

### Technical Questions

**Q: Why is my virtual environment not working?**
A: Ensure you activate it correctly: `.\.venv\Scripts\Activate.ps1` on Windows.

**Q: How do I fix flake8 errors?**
A: Run `flake8 .` locally and fix style issues before pushing to trigger workflows.

**Q: What if the model prediction is wrong?**
A: The model is trained on limited data. Focus on demonstrating the ML integration, not accuracy.

**Q: How do I add more test data?**
A: Add rows to `meditation_sessions.csv` following the same format, then retrain with `python model/train.py`.

---

## Emergency Fixes

### Last-Minute Issues (5 minutes before demo)

**If Docker won't start**:
```powershell
# Use local Python instead
python app.py
# Show endpoints in browser
```

**If GitHub Actions failing**:
```powershell
# Show local test results instead
python -m pytest tests/ -v
python -m flake8 .
```

**If model not loading**:
```powershell
# Retrain quickly
python model/train.py
# Restart application
```

**If nothing works**:
- Show code quality (clean, documented code)
- Demonstrate understanding by explaining architecture
- Show documentation completeness
- Walk through Jenkinsfile and workflows

### Quick Health Check Script

```powershell
# Save as health-check.ps1
Write-Host "=== Health Check ===" -ForegroundColor Green

# Check Python
try { python --version; Write-Host "✅ Python OK" -ForegroundColor Green }
catch { Write-Host "❌ Python Issue" -ForegroundColor Red }

# Check Docker
try { docker --version; Write-Host "✅ Docker OK" -ForegroundColor Green }
catch { Write-Host "❌ Docker Issue" -ForegroundColor Red }

# Check files
if (Test-Path "app.py") { Write-Host "✅ App file exists" -ForegroundColor Green }
if (Test-Path "model/model.pkl") { Write-Host "✅ Model exists" -ForegroundColor Green }
if (Test-Path "data/group_01/meditation_sessions.csv") { Write-Host "✅ Dataset exists" -ForegroundColor Green }

# Test virtual environment
.\.venv\Scripts\Activate.ps1
try { 
    python -c "import flask, pandas, sklearn" 
    Write-Host "✅ Dependencies OK" -ForegroundColor Green 
} catch { 
    Write-Host "❌ Dependencies Issue" -ForegroundColor Red 
}

Write-Host "Health check complete!" -ForegroundColor Green
```

---

## Getting Help

### Resources
- **GitHub Repository**: https://github.com/roshi12/mlops-assignment
- **Docker Documentation**: https://docs.docker.com/
- **Flask Documentation**: https://flask.palletsprojects.com/
- **GitHub Actions Guide**: https://docs.github.com/en/actions

### Contact
- Repository Issues: Create issue on GitHub repo
- Documentation: Check docs/ folder for detailed guides

---

**Guide Version**: 1.0  
**Last Updated**: September 20, 2025  
**Coverage**: All major components and common issues