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
            stage('Package') {
              steps {
                echo 'Build'
                sh 'mvn package -DskipTests=true'
              }
            }
            stage ('test') {
              steps {
                //parallel (
                //  "unit tests": { sh 'mvn test' },
                //  "integration tests": { sh 'mvn integration-test' }
                //)
                sh 'mvn test'
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
        stage('Build Docker image') {
          agent any
          steps {
            echo 'Build Docker image'
            sh 'docker build -t springboot/springbootexample:latest'
          }
        }
        stage('Publish') {
          agent any
          steps {
            echo 'Publish'
            sh 'docker images'
            //sh('docker tag springboot/springbootexample latest')
          }
        }
    }
}
