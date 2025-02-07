pipeline {
    agent {
        node {
            label 'maven'
        }
    }

    environment {
        PATH = "/opt/apache-maven-3.9.9/bin:$PATH"
    }

    stages {
        stage("Build") {
            steps {
                sh 'mvn clean deploy'
            }
        }
        stage("SonarQube analysis") {
            environment {
                scannerHome = tool 'valaxxy-sonarqube-server';
            }
            steps {
                withSonarQubeEnv('valaxxy-sonarqube-server') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
    }
}
