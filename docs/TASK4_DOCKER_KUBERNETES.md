# Task 4: Docker Hub & Kubernetes Deployment

This document provides complete instructions for Task 4 of the MLOps assignment: pushing the Docker image to Docker Hub and deploying to Kubernetes.

## 📋 Overview

Task 4 consists of two main parts:
1. **Push Docker image to Docker Hub**
2. **Deploy application to Kubernetes using Deployment and Service manifests**

## 🐳 Part 1: Push Image to Docker Hub

### Prerequisites

- Docker Desktop installed and running
- Docker Hub account (username: `bilalrazaswe`)
- Internet connection for pushing to Docker Hub

### Method 1: Using the Automated Script (Recommended)

1. **Ensure Docker Desktop is running**
   - Start Docker Desktop application
   - Wait for it to fully start (check system tray icon)

2. **Run the push script:**
   ```powershell
   .\docker-push.ps1
   ```

3. **Follow the prompts:**
   - Login to Docker Hub when prompted
   - Enter your Docker Hub password/token
   - Wait for build and push to complete

### Method 2: Manual Commands

```powershell
# Step 1: Login to Docker Hub
docker login

# Step 2: Build the image
docker build -t bilalrazaswe/focus-meditation-agent:latest .

# Step 3: Push to Docker Hub
docker push bilalrazaswe/focus-meditation-agent:latest

# Step 4: Verify
docker images | Select-String "focus-meditation-agent"
```

### Verification

Once pushed, verify the image on Docker Hub:
- URL: https://hub.docker.com/r/bilalrazaswe/focus-meditation-agent
- Check that the image appears with the `latest` tag
- Verify the push timestamp is recent

## ☸️ Part 2: Deploy to Kubernetes

### Prerequisites

- Kubernetes cluster running (one of):
  - **Docker Desktop** with Kubernetes enabled
  - **Minikube** installed and started
  - **Cloud cluster** (GKE, EKS, AKS) configured
- kubectl installed and configured
- Docker image pushed to Docker Hub (Part 1 completed)

### Setup Kubernetes Cluster

#### Option A: Docker Desktop
1. Open Docker Desktop
2. Go to Settings → Kubernetes
3. Check "Enable Kubernetes"
4. Click "Apply & Restart"
5. Wait for Kubernetes to start

#### Option B: Minikube
```powershell
# Start Minikube
minikube start

# Verify
kubectl cluster-info
```

### Deployment Files Created

The following Kubernetes manifests have been created in the `k8s/` directory:

1. **deployment.yaml**
   - 3 replica pods for high availability
   - Health checks (liveness & readiness probes)
   - Resource limits (CPU & memory)
   - Auto-restart policy

2. **service.yaml**
   - LoadBalancer service type
   - Maps port 80 → 5000
   - For cloud environments

3. **service-nodeport.yaml**
   - NodePort service type
   - Exposes port 30080
   - For local development

### Method 1: Using the Deployment Script (Recommended)

```powershell
.\k8s-deploy.ps1
```

This script will:
- ✅ Check prerequisites (kubectl, cluster connection)
- ✅ Deploy the application
- ✅ Create the service (you choose LoadBalancer or NodePort)
- ✅ Wait for pods to be ready
- ✅ Display access information

### Method 2: Manual Deployment

#### Step 1: Verify Cluster Connection
```powershell
kubectl cluster-info
kubectl get nodes
```

#### Step 2: Deploy the Application
```powershell
# Apply deployment
kubectl apply -f k8s/deployment.yaml

# Verify deployment
kubectl get deployment focus-meditation-agent
```

#### Step 3: Create the Service

**For Cloud Environments (LoadBalancer):**
```powershell
kubectl apply -f k8s/service.yaml
```

**For Local Development (NodePort):**
```powershell
kubectl apply -f k8s/service-nodeport.yaml
```

#### Step 4: Wait for Pods to Start
```powershell
kubectl rollout status deployment/focus-meditation-agent
kubectl get pods -l app=focus-meditation-agent
```

#### Step 5: Get Access Information

**For LoadBalancer:**
```powershell
kubectl get service focus-meditation-agent
# Look for EXTERNAL-IP (may take a few minutes)
```

**For NodePort:**
```powershell
kubectl get service focus-meditation-agent-nodeport
# Access via: http://localhost:30080 (Docker Desktop)
# Or: minikube service focus-meditation-agent-nodeport (Minikube)
```

## 🧪 Testing the Deployment

### Check Deployment Status
```powershell
# View all resources
kubectl get all -l app=focus-meditation-agent

# Check pod logs
kubectl logs -l app=focus-meditation-agent

# Describe deployment
kubectl describe deployment focus-meditation-agent
```

### Test API Endpoints

Replace `<SERVICE-URL>` with your actual service URL:
- **LoadBalancer:** External IP from `kubectl get service`
- **NodePort (Docker Desktop):** `localhost:30080`
- **NodePort (Minikube):** Get URL from `minikube service focus-meditation-agent-nodeport --url`

```powershell
# Health check
curl http://<SERVICE-URL>/

# Expected: {"status":"ok","msg":"Focus Meditation Agent"}

# Get sessions
curl http://<SERVICE-URL>/sessions

# Get statistics
curl http://<SERVICE-URL>/stats

# Make a prediction
curl -X POST http://<SERVICE-URL>/predict `
  -H "Content-Type: application/json" `
  -d '{"duration_minutes": 20, "mood_before": 5}'
```

## 📊 Deployment Details

### Kubernetes Resources Created

| Resource | Name | Type | Description |
|----------|------|------|-------------|
| Deployment | focus-meditation-agent | apps/v1 | 3 replicas with health checks |
| Service | focus-meditation-agent | LoadBalancer/NodePort | Exposes application |
| Pods | focus-meditation-agent-* | v1 | Running application containers |

### Deployment Configuration

```yaml
Replicas: 3
Image: bilalrazaswe/focus-meditation-agent:latest
Port: 5000
Resources:
  Requests: 256Mi RAM, 250m CPU
  Limits: 512Mi RAM, 500m CPU
Health Checks:
  Liveness: HTTP GET / (every 10s)
  Readiness: HTTP GET / (every 5s)
```

### Service Configuration

**LoadBalancer:**
- External Port: 80
- Target Port: 5000
- Type: LoadBalancer

**NodePort:**
- External Port: 30080
- Target Port: 5000
- Type: NodePort

## 🔧 Management Commands

### View Logs
```powershell
# All pods
kubectl logs -l app=focus-meditation-agent

# Specific pod
kubectl logs <pod-name>

# Follow logs
kubectl logs -f -l app=focus-meditation-agent
```

### Scale Application
```powershell
# Scale to 5 replicas
kubectl scale deployment focus-meditation-agent --replicas=5

# Verify scaling
kubectl get pods -l app=focus-meditation-agent
```

### Update Application
```powershell
# After pushing new image to Docker Hub
kubectl rollout restart deployment/focus-meditation-agent

# Check rollout status
kubectl rollout status deployment/focus-meditation-agent
```

### Delete Deployment
```powershell
# Using cleanup script
.\k8s-cleanup.ps1

# Or manually
kubectl delete -f k8s/
```

## 🐛 Troubleshooting

### Issue: Docker Desktop Not Running
**Error:** `error during connect: ... dockerDesktopLinuxEngine`

**Solution:**
1. Start Docker Desktop
2. Wait for it to fully initialize
3. Check system tray icon shows Docker is running

### Issue: Kubernetes Not Enabled
**Error:** `The connection to the server localhost:8080 was refused`

**Solution:**
1. Open Docker Desktop Settings
2. Enable Kubernetes
3. Apply and restart
4. Wait for Kubernetes to start

### Issue: Pods Not Starting
**Error:** `ImagePullBackOff` or `ErrImagePull`

**Solution:**
1. Verify image exists on Docker Hub
2. Check image name in deployment.yaml matches
3. Try: `docker pull bilalrazaswe/focus-meditation-agent:latest`

### Issue: Service Not Accessible
**Error:** Cannot connect to service URL

**Solution:**
1. Check pod status: `kubectl get pods -l app=focus-meditation-agent`
2. View logs: `kubectl logs -l app=focus-meditation-agent`
3. Verify service: `kubectl get service`
4. For NodePort, ensure using correct port (30080)

### Issue: External IP Pending (LoadBalancer)
**Status:** `<pending>` in EXTERNAL-IP column

**Solution:**
- **Docker Desktop/Minikube:** LoadBalancer not supported, use NodePort instead
- **Cloud:** Wait a few minutes for cloud provider to assign IP
- Alternative: Switch to NodePort service

## 📝 Verification Checklist

### Part 1: Docker Hub
- [ ] Docker Desktop is running
- [ ] Successfully logged into Docker Hub
- [ ] Image built successfully
- [ ] Image pushed to Docker Hub
- [ ] Image visible on Docker Hub website
- [ ] Image can be pulled: `docker pull bilalrazaswe/focus-meditation-agent:latest`

### Part 2: Kubernetes
- [ ] Kubernetes cluster is running
- [ ] kubectl is installed and working
- [ ] Deployment created successfully
- [ ] All 3 pods are running
- [ ] Service created successfully
- [ ] Service has external access (IP or NodePort)
- [ ] Health check endpoint (/) returns 200 OK
- [ ] All API endpoints are accessible
- [ ] Application responds correctly to test requests

## 📚 Additional Resources

### Files Created
- `docker-push.ps1` - Automated Docker Hub push script
- `k8s-deploy.ps1` - Automated Kubernetes deployment script
- `k8s-cleanup.ps1` - Cleanup script for Kubernetes resources
- `k8s/deployment.yaml` - Kubernetes Deployment manifest
- `k8s/service.yaml` - LoadBalancer Service manifest
- `k8s/service-nodeport.yaml` - NodePort Service manifest
- `k8s/README.md` - Detailed Kubernetes documentation

### Documentation
- [Kubernetes README](k8s/README.md) - Detailed K8s documentation
- [Main README](README.md) - Project overview
- [API Documentation](docs/API.md) - API endpoint details
- [Deployment Guide](docs/DEPLOYMENT.md) - General deployment info

### Useful Commands Reference
```powershell
# Docker
docker build -t IMAGE .
docker push IMAGE
docker images
docker pull IMAGE

# Kubernetes
kubectl get all
kubectl get pods
kubectl get services
kubectl get deployments
kubectl logs POD_NAME
kubectl describe POD_NAME
kubectl delete -f FILE.yaml
kubectl apply -f FILE.yaml

# Cluster Management
kubectl cluster-info
kubectl get nodes
kubectl config current-context
```

## ✅ Success Criteria

Task 4 is complete when:
1. ✅ Docker image is pushed to Docker Hub
2. ✅ Image is publicly accessible on Docker Hub
3. ✅ Kubernetes Deployment manifest created
4. ✅ Kubernetes Service manifest created
5. ✅ Application deployed to Kubernetes cluster
6. ✅ All 3 pods are running and healthy
7. ✅ Service is accessible via external IP or NodePort
8. ✅ All API endpoints respond correctly
9. ✅ Application can handle requests in Kubernetes environment

---

**Date Completed:** October 9, 2025  
**Repository:** https://github.com/roshi12/mlops-assignment  
**Docker Hub:** https://hub.docker.com/r/bilalrazaswe/focus-meditation-agent
