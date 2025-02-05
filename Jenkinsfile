pipeline {
    agent {
        node{
            label 'maven-slave'
        }
    }

    stages {
        stage('Cloning-code') {
            steps {
                git branch: 'main', credentialsId: 'Github', url: 'https://github.com/AyoFagbuaro/tweet-trend.git'
            }
        }
    }
}
