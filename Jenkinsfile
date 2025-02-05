pipeline {
    agent {
        node{
            label 'maven'
        }
    }

    environment {
        PATH = "$MAVEN_HOME/bin:$PATH"   
    }

    stages {
        stage('Build') {
            steps {
                sh 'mvn clean deploy'
            }
        }
    }
}
