pipeline {
  agent {
    docker {
      image 'gradle:alpine'
    }

  }
  stages {
    stage('Build') {
      steps {
        sh './gradlew build'
      }
    }
  }
  post {
    always {
      cleanWs()

    }

  }
}