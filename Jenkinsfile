pipeline {
    agent any

    stages {
        stage('Clean-up') {
            steps {
                sh """
                    docker rm -f flask-app mynginx 2>/dev/null || true
                    docker network rm app-network 2>/dev/null || true
                    """
            }
        }

        stage('Set-up') {
            steps {
                echo 'Setting up network...'
                sh 'docker network create app-network || true'
            }
        }

        stage('Build Images') {
            steps {
                sh 'Building Docker images...'
                sh 'docker build -t flask-app .'
                sh 'docker build -t mynginx -f Dockerfile.nginx .'
            }
        }

        stage('Run Containers') {
            steps {
                echo 'Running Docker containers...'
                sh 'docker run -d --name flask-app --network app-network flask-app:latest'
                sh 'docker run -d -p 80:80 --name mynginx --network app-network mynginx:latest'
            }
        }

        stage('Manual Check') {
            steps {
                echo 'Manual check: Access the application in the browser at http://localhost:5500 or use curl.'
            }
        }

        stage('Trivy FS Scan') {
            steps {
                echo 'Running Trivy filesystem scan...'
                sh 'trivy fs --format json -o trivi-report.json .'
        }
            post {
                always {
                // Archive the Trivy report
                archiveArtifacts artifacts: 'trivi-report.json', onlyIfSuccessful: true
                }
            }
        }
                stage('Trivy Image Scan') {
            steps {
                echo 'Running Trivy image scan...'
                sh 'trivy image --format json -o trivy-image-report.json flask-app:latest'
                sh 'trivy image --format json -o trivy-nginx-report.json mynginx:latest'
            }
            post {
                always {
                    archiveArtifacts artifacts: 'trivy-image-report.json, trivy-nginx-report.json', onlyIfSuccessful: true
                }
            }
        }
                stage('Unit Test') {
            steps {
                echo 'Setting up virtual environment...'
                sh 'python3 -m venv venv'
                sh './venv/bin/pip install -r requirements.txt'
                echo 'Running unit tests...'
                catchError(buildResult: 'UNSTABLE', stageResult: 'UNSTABLE') {
                    sh './venv/bin/python -m unittest discover -s tests'
                }
            }
        }
}
