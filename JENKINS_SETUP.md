# Jenkins Setup Guide for MLOps Assignment

## Quick Jenkins Setup

### Option 1: Using Docker (Recommended for Demo)
```powershell
# Start Jenkins in Docker (easier for demo)
docker run -d -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts

# Get initial admin password
docker exec $(docker ps -q --filter ancestor=jenkins/jenkins:lts) cat /var/jenkins_home/secrets/initialAdminPassword
```

### Option 2: Download Jenkins WAR
1. Download jenkins.war from https://jenkins.io/download/
2. Run: `java -jar jenkins.war --httpPort=8080`
3. Open: http://localhost:8080

## Jenkins Configuration Steps

1. **Install Jenkins** (using option above)
2. **Setup Admin User** 
3. **Install Plugins:**
   - Docker Pipeline
   - Email Extension Plugin
   - GitHub Plugin

4. **Configure Credentials:**
   - Docker Hub username/password as `dockerhub-creds`
   - GitHub token if needed

5. **Create Pipeline Job:**
   - New Item → Pipeline
   - Pipeline script from SCM → Git
   - Repository URL: https://github.com/roshi12/mlops-assignment.git
   - Branch: master
   - Script Path: Jenkinsfile

6. **Configure Email:**
   - Manage Jenkins → Configure System → Email Notification
   - SMTP server configuration

## What to Show Teacher

1. **Jenkins Dashboard** - http://localhost:8080
2. **Pipeline Job** - Show the configured job
3. **Build History** - Show successful/failed builds
4. **Console Output** - Show Docker build and push logs
5. **Email Notifications** - Show email configuration

## Demo Flow
1. Make change to master branch
2. Show Jenkins automatically triggers
3. Show Docker build process in console
4. Show image pushed to Docker Hub
5. Show email notification sent