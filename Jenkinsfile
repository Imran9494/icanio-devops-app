pipeline {
    agent any

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
    }

    post {
        success {
            echo 'Build and Test completed successfully!'
        }

        failure {
            echo 'Build or Test failed.'
        }
    }
}
