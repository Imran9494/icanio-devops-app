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
                    script {
                        env.IMAGE_URI = "${DOCKER_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"
                    }

                    sh '''
                        echo "$DOCKER_PASSWORD" | docker login \
                          -u "$DOCKER_USERNAME" \
                          --password-stdin

                        docker tag \
                          ${IMAGE_NAME}:${IMAGE_TAG} \
                          ${IMAGE_URI}

                        docker push ${IMAGE_URI}

                        docker logout
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    aws eks update-kubeconfig \
                      --region us-east-1 \
                      --name icanio-devops-cluster

                    kubectl set image \
                      deployment/icanio-devops-app \
                      icanio-devops-app=${IMAGE_URI} \
                      -n icanio

                    kubectl rollout status \
                      deployment/icanio-devops-app \
                      -n icanio \
                      --timeout=180s
                '''
            }
        }
    }

    post {
        success {
            echo 'CI/CD pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed. Check the stage logs above.'
        }
    }
}