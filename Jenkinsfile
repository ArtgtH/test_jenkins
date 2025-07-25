pipeline {
    agent {
        label 'docker-agent'
    }
    environment {
        REGISTRY = "nexus:8082"
        REPO_NAME = "python-app"
        IMAGE_NAME = "${REGISTRY}/${REPO_NAME}"
		BUILD_TAG = "build-${BUILD_NUMBER}"
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '20'))
        timeout(time: 15, unit: 'MINUTES')
        disableConcurrentBuilds()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                sh 'STARTED'
            }
        }

        stage('Build Images') {
            steps {
                script {
                    docker.build("test-${IMAGE_NAME}:${BUILD_TAG}", "--target tester .")
                    docker.build("${IMAGE_NAME}:${BUILD_TAG}")
                }
            }
        }

        stage('Run Linter') {
            steps {
                script {
                    docker.image("test-${IMAGE_NAME}:${BUILD_TAG}").inside("--entrypoint=''") {
                        sh 'poetry run ruff check ./src'
                        sh 'poetry run ruff format ./src --check'
                    }
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    docker.image("test-${IMAGE_NAME}:${BUILD_TAG}").inside("--entrypoint=''") {
                        sh 'poetry run pytest .'
                    }
                }
            }
        }

        stage('Push to Nexus') {
            when {
                allOf {
                    expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
                    branch 'main'
                }
            }
            steps {
                script {
                    docker.withRegistry("https://${REGISTRY}", 'nexus-credentials') {
                        docker.image("${IMAGE_NAME}:${BUILD_TAG}").push()
                    }
                }
            }
        }
    }

    post {
        always {
			sh 'docker system prune -f --filter "until=24h"'
        }

        success {
            echo 'I succeeded'
        }
    }
}