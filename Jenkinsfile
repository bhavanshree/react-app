pipeline {
    agent any // Ensure you have an agent/node configured with Ubuntu
    
    environment {
        DOCKER_USERNAME = credentials('DOCKER_USERNAME') // Jenkins credentials ID
        DOCKER_PASSWORD = credentials('DOCKER_PASSWORD') // Jenkins credentials ID
    }

    stages {
        stage('Checkout repository') {
            steps {
                checkout scm
            }
        }

        stage('Set up Docker Buildx') {
            steps {
                sh 'docker run --privileged --rm tonistiigi/binfmt --install all'
            }
        }

        stage('Log in to Docker Hub') {
            steps {
                sh 'echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin'
            }
        }

        stage('Get the latest tag from Docker Hub') {
            steps {
                script {
                    def token = sh(
                        script: '''
                        curl -s -X POST "https://hub.docker.com/v2/users/login/" \
                        -H "Content-Type: application/json" \
                        -d '{"username": "'"$DOCKER_USERNAME"'", "password": "'"$DOCKER_PASSWORD"'"}' | jq -r .token
                        ''',
                        returnStdout: true
                    ).trim()
                    
                    if (!token) {
                        error("Failed to retrieve Docker Hub token.")
                    }
                    
                    def latestTag = sh(
                        script: """
                        curl -s "https://hub.docker.com/v2/repositories/$DOCKER_USERNAME/react-jenkins/tags/?page_size=1" \
                        -H "Authorization: Bearer $token" | jq -r '.results[0].name'
                        """,
                        returnStdout: true
                    ).trim()
                    
                    if (!latestTag || latestTag == "null") {
                        latestTag = "v0" // Default to "v0" if no tag exists
                    }
                    
                    env.LATEST_TAG = latestTag
                    echo "Latest tag: ${env.LATEST_TAG}"
                }
            }
        }

        stage('Increment Docker image tag') {
            steps {
                script {
                    def match = (env.LATEST_TAG =~ /v(\d+)/)
                    if (match) {
                        def patch = match[0][1].toInteger()
                        env.NEW_TAG = "v${patch + 1}"
                    } else {
                        env.NEW_TAG = "v1" // Start with v1 if LATEST_TAG is not in expected format
                    }
                    echo "New Docker tag: ${env.NEW_TAG}"
                }
            }
        }

        stage('Build Docker image') {
            steps {
                    sh """
                    docker build -t $DOCKER_USERNAME/react-jenkins:${env.NEW_TAG} -f Dockerfile .
                    """
            }
        }

        stage('Push Docker image to Docker Hub') {
            steps {
                sh "docker push $DOCKER_USERNAME/react-jenkins:${env.NEW_TAG}"
            }
        }
    }

    post {
        always {
            cleanWs() // Clean up workspace after execution
        }
    }
}
