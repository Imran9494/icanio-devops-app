pipeline {

    agent any

    environment {
        IMAGE_NAME = "icanio-devops-app"
        IMAGE_TAG  = "${BUILD_NUMBER}"
    }

    stages {

        stage('Build') {
            steps {
                sh './mvnw clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                sh './mvnw test'
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker build \
                      -t ${IMAGE_NAME}:${IMAGE_TAG} \
                      .
                '''
            }
        }

        stage('Image Scan') {
            steps {
                sh '''
                    trivy image \
                      --severity CRITICAL \
                      --exit-code 1 \
                      ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }
	stage('Push to Registry') {
    steps {
        withCredentials([
            usernamePassword(
                credentialsId: 'dockerhub-credentials',
                usernameVariable: 'DOCKER_USERNAME',
                passwordVariable: 'DOCKER_PASSWORD'
            )
        ]) {
            sh '''
                echo "$DOCKER_PASSWORD" | docker login \
                    -u "$DOCKER_USERNAME" \
                    --password-stdin

                docker tag \
                    icanio-devops-app:${IMAGE_TAG} \
                    ${DOCKERHUB_REPO}:${IMAGE_TAG}

                docker push \
                    "$DOCKER_USERNAME/${IMAGE_NAME}:${IMAGE_TAG}"

                docker logout
            '''
        }
    }
}
    }

    post {
        success {
            echo 'Build, Test, Docker Build and Image Scan completed successfully!'
        }

        failure {
            echo 'Pipeline failed. Check the stage logs above.'
        }
    }
}

