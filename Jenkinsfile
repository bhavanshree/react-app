pipeline {
    agent any
    stages {
        stage('Deploy to Server') {
            steps {
                sshagent(['REMOTE_SSH']) {
                    script {
                        sh '''
                            ssh -o StrictHostKeyChecking=no ubuntu@$REMOTE_IP << EOF
                                cd /home/ubuntu/react
                                bash hello.sh
                            EOF
                        '''
                    }
                }
            }
        }
    }
}
