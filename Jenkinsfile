pipeline {
    agent {
        node{
            label 'maven-slave'
        }
    }

    stages {
        stage('Build') {
            steps {
                sh 'mvn clean deploy'
            }
        }
    }
}
