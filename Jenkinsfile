pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build') {
      steps {
        sh 'echo Build started'
        sh 'pwd'
        sh 'ls -la'
      }
    }

    stage('Test') {
      steps {
        sh 'echo No tests configured'
      }
    }
  }

  post {
    always {
      echo 'Pipeline finished'
    }
  }
}
