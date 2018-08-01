pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'chmod +x ./gradlew'
        sh './gradlew build'
      }
    }
  }
  post {
    always {
        archiveArtifacts artifacts: 'build/libs/**/*.jar', fingerprint: true
    }
  }
}