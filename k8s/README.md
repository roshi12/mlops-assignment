# Kubernetes Deployment Guide

This directory contains Kubernetes manifests for deploying the Focus Meditation Agent application.

## 📁 Files

- **deployment.yaml** - Deployment configuration with 3 replicas, health checks, and resource limits
- **service.yaml** - LoadBalancer service (for cloud environments)
- **service-nodeport.yaml** - NodePort service (for local development)

## 🚀 Quick Start

### Prerequisites

1. **Kubernetes Cluster** - One of the following:
   - Minikube (local development)
   - Docker Desktop with Kubernetes enabled
   - Cloud provider (GKE, EKS, AKS)
   
2. **kubectl** - Kubernetes command-line tool
   ```powershell
   kubectl version --client
   ```

3. **Docker Image** - Push to Docker Hub first:
   ```powershell
   .\docker-push.ps1
   ```

### Option 1: Using the Deployment Script (Recommended)

```powershell
.\k8s-deploy.ps1
```

This interactive script will:
- ✅ Check kubectl installation
- ✅ Verify cluster connection
- ✅ Deploy the application
- ✅ Create the service (LoadBalancer or NodePort)
- ✅ Wait for pods to be ready
- ✅ Display access information

### Option 2: Manual Deployment

#### Step 1: Apply the Deployment
```powershell
kubectl apply -f k8s/deployment.yaml
```

#### Step 2: Apply the Service

**For Cloud Environments (LoadBalancer):**
```powershell
kubectl apply -f k8s/service.yaml
```

**For Local Development (NodePort):**
```powershell
kubectl apply -f k8s/service-nodeport.yaml
```

#### Step 3: Verify Deployment
```powershell
kubectl get pods -l app=focus-meditation-agent
kubectl get deployment focus-meditation-agent
kubectl get service -l app=focus-meditation-agent
```

#### Step 4: Wait for Rollout
```powershell
kubectl rollout status deployment/focus-meditation-agent
```

## 🌐 Accessing the Application

### LoadBalancer Service
```powershell
# Get the external IP
kubectl get service focus-meditation-agent

# Access the application
# http://<EXTERNAL-IP>
```

### NodePort Service

**Docker Desktop:**
```
http://localhost:30080
```

**Minikube:**
```powershell
minikube service focus-meditation-agent-nodeport
```

## 🔍 Testing the Endpoints

Once deployed, test the API endpoints:

```powershell
# Health check
curl http://<SERVICE-URL>/

# Get all sessions
curl http://<SERVICE-URL>/sessions

# Get statistics
curl http://<SERVICE-URL>/stats

# Make a prediction
curl -X POST http://<SERVICE-URL>/predict `
  -H "Content-Type: application/json" `
  -d '{"duration_minutes": 20, "mood_before": 5}'
```

## 📊 Deployment Configuration Details

### Deployment Specification

- **Replicas:** 3 pods for high availability
- **Image:** `bilalrazaswe/focus-meditation-agent:latest`
- **Image Pull Policy:** Always (ensures latest version)
- **Port:** 5000 (Flask application)

### Resource Limits

```yaml
resources:
  requests:
    memory: "256Mi"
    cpu: "250m"
  limits:
    memory: "512Mi"
    cpu: "500m"
```

### Health Checks

**Liveness Probe:**
- Checks if the container is alive
- HTTP GET request to `/` endpoint
- Initial delay: 30 seconds
- Period: 10 seconds

**Readiness Probe:**
- Checks if the container is ready to serve traffic
- HTTP GET request to `/` endpoint
- Initial delay: 10 seconds
- Period: 5 seconds

### Service Configuration

**LoadBalancer Service:**
- External port: 80
- Internal port: 5000
- Automatically provisions external IP

**NodePort Service:**
- External port: 30080
- Internal port: 5000
- Accessible via node IP + port

## 🛠️ Management Commands

### View Logs
```powershell
# All pods
kubectl logs -l app=focus-meditation-agent

# Specific pod
kubectl logs <pod-name>

# Follow logs
kubectl logs -f -l app=focus-meditation-agent
```

### Scale Deployment
```powershell
# Scale to 5 replicas
kubectl scale deployment focus-meditation-agent --replicas=5

# Scale to 1 replica
kubectl scale deployment focus-meditation-agent --replicas=1
```

### Update Deployment
```powershell
# After pushing a new image to Docker Hub
kubectl rollout restart deployment/focus-meditation-agent

# Check rollout status
kubectl rollout status deployment/focus-meditation-agent

# View rollout history
kubectl rollout history deployment/focus-meditation-agent
```

### Delete Deployment
```powershell
# Delete all resources
kubectl delete -f k8s/

# Or delete individually
kubectl delete deployment focus-meditation-agent
kubectl delete service focus-meditation-agent
```

## 🐛 Troubleshooting

### Pods Not Starting

```powershell
# Check pod status
kubectl get pods -l app=focus-meditation-agent

# Describe pod for details
kubectl describe pod <pod-name>

# Check events
kubectl get events --sort-by=.metadata.creationTimestamp
```

### Image Pull Errors

```powershell
# Verify the image exists on Docker Hub
docker pull bilalrazaswe/focus-meditation-agent:latest

# Check image pull policy in deployment.yaml
# Make sure the image name is correct
```

### Service Not Accessible

```powershell
# Check service endpoints
kubectl get endpoints focus-meditation-agent

# Check if pods are ready
kubectl get pods -l app=focus-meditation-agent

# For NodePort, verify the port
kubectl get service focus-meditation-agent-nodeport
```

### Connection Issues

```powershell
# Check cluster info
kubectl cluster-info

# Check node status
kubectl get nodes

# Verify context
kubectl config current-context
```

## 📈 Monitoring

### View Pod Status
```powershell
kubectl get pods -l app=focus-meditation-agent -w
```

### Resource Usage
```powershell
# Requires metrics-server
kubectl top pods -l app=focus-meditation-agent
kubectl top nodes
```

### Deployment Status
```powershell
kubectl get deployment focus-meditation-agent -o wide
```

## 🔄 CI/CD Integration

To integrate with your existing CI/CD pipeline:

1. **Build and Push Image:**
   ```powershell
   docker build -t bilalrazaswe/focus-meditation-agent:latest .
   docker push bilalrazaswe/focus-meditation-agent:latest
   ```

2. **Update Deployment:**
   ```powershell
   kubectl set image deployment/focus-meditation-agent focus-meditation-agent=bilalrazaswe/focus-meditation-agent:latest
   ```

3. **Wait for Rollout:**
   ```powershell
   kubectl rollout status deployment/focus-meditation-agent
   ```

## 📝 Notes

- The deployment uses a multi-stage Dockerfile for optimized image size
- Health checks ensure only healthy pods receive traffic
- Resource limits prevent pods from consuming excessive resources
- Session affinity is disabled for better load distribution
- The application is stateless and can be scaled horizontally

## 🔗 Related Documentation

- [Main README](../README.md)
- [API Documentation](../docs/API.md)
- [Architecture](../docs/ARCHITECTURE.md)
- [Deployment Guide](../docs/DEPLOYMENT.md)
