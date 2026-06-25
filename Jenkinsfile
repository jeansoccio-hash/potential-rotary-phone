pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building the application...'
                sh 'mkdir build || true'
                sh 'touch build/app.jar'
                sh 'ls -l build'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'mkdir test-results || true'
                sh 'touch test-results/test-report.xml'
                sh 'ls -l test-results'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying the application...'
                sh 'mkdir deploy || true'
                sh 'mv build/app.jar deploy/'
                sh 'ls -l deploy'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            sh 'rm -rf build test-results deploy'
        }
    }
}