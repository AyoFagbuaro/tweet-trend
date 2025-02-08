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

        stage("SonarQube-analysiis") {
            environment {
                scannerHome = tool 'valaxxy-sonar-scanner';
            }
            steps {
                withSonarQubeEnv('valaxxy-sonarqube-server') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
        stage("Quality Gate"){
            steps{
                script {
                    timeout(time: 1, unit: 'HOURS') { // Just in case something goes wrong, pipeline will be killed after a timeout
                    def qg = waitForQualityGate() // Reuse taskId previously collected by withSonarQubeEnv
                    if (qg.status != 'OK') {
                    error "Pipeline aborted due to quality gate failure: ${qg.status}"
                         }
                    }
                }
            }
        }
    }
}
