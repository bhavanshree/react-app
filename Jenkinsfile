/* Requires the Docker Pipeline plugin */
pipeline {
    agent { docker { image 'node:22.11.0-alpine3.20' } }
    stages {
        stage('build') {
            steps {
                sh 'node --version'
            }
        }
    }
}
