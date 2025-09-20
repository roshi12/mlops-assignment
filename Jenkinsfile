pipeline {
  agent any

  environment {
    DOCKERHUB_REPO = "your-dockerhub-username/focus-meditation-agent"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          def tag = "${env.BUILD_NUMBER}"
          def imageName = "${DOCKERHUB_REPO}:${tag}"
          sh "docker build -t ${imageName} ."
          env.IMAGE_NAME = imageName
        }
      }
    }

    stage('Login to DockerHub & Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
          sh 'echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin'
          sh "docker push ${env.IMAGE_NAME}"
        }
      }
    }
  }

  post {
    success {
      emailext (
        subject: "Jenkins: Build #${env.BUILD_NUMBER} Succeeded for ${env.JOB_NAME}",
        body: """Build succeeded!
                 Job: ${env.JOB_NAME}
                 Build: ${env.BUILD_URL}
                 Image: ${env.IMAGE_NAME}
              """,
        to: "admin@example.com"
      )
    }
    failure {
      emailext (
        subject: "Jenkins: Build #${env.BUILD_NUMBER} FAILED for ${env.JOB_NAME}",
        body: "Build failed. See ${env.BUILD_URL}",
        to: "admin@example.com"
      )
    }
  }
}
