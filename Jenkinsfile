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
                echo '-----Building started-----'
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                echo '-----Building completed-----'
            }
        }

        stage ("test") {
            steps {
                echo '-----Unit testing started-----'
                sh 'mvn surefire-report:report'
                echo '-----Unit testing completed-----'
            }
        }


        stage("SonarQube analysiiis") {
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
