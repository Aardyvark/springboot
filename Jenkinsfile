pipeline {
    agent none
    stages {
        stage('Environment') {
          agent any
          steps {
            sh('printenv')
            //sh('docker images')
          }
        }
        stage('Start Build') {
          agent { docker 'maven:3-alpine' }
          stages {
            stage('Effective POM') {
              steps {
                echo 'Effective POM'
                sh 'mvn help:effective-pom'
              }
            }
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
          }
        }
        stage('Publish') {
          agent any
          steps {
            echo 'Publish'
            sh('docker images')
            //sh('docker tag springboot/springbootexample latest')
          }
        }
    }
}
