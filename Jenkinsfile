pipeline {
    agent none
    stages {
        stage('Environment') {
            agent any
            steps {
                sh('printenv')
            }
        }
        stage('Build / Publish') {
            agent { docker 'maven:3-alpine' }
            stages {
                stage('Build') {
                    steps {
                      echo 'Packaging'
                      sh 'mvn -Dmaven.test.failure.ignore=true install'
                    }
                    post {
                        always {
                          //archive "target/**/*"
                          junit 'target/surefire-reports/**/*.xml'
                        }
                    }
                }
                stage('Tag') {
                    steps {
                      sh('docker tag localhost:32800/springboot/springbootexample localhost:32800/springboot/springbootexample:latest')
                    }
                }
                stage('Publish') {
                    steps {
                      echo 'Publish'
                      sh 'mvn docker:push'
                    }
                }
            }
        }
    }
}
