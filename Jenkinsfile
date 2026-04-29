pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        echo 'Checking out source code'
        checkout scm
      }
    }

    stage('Build') {
      steps {
        echo 'Running sample build steps'
        sh 'echo Build started'
        sh 'pwd'
        sh 'ls -la'
      }
    }

    stage('Test') {
      steps {
        echo 'Running sample tests'
        sh 'echo No tests configured yet'
      }
    }
  }

  post {
    always {
      echo 'Pipeline finished'
    }
    success {
      echo 'Build succeeded'
    }
    failure {
      echo 'Build failed'
    }
  }
}
