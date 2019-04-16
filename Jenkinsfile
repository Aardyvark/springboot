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
            stage('test') {
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
        stage('tag') {
          agent any
          steps {
            echo 'tag'
            sh 'git describe --tags --always'
          }
        }
        stage('Build Docker image') {
          agent any
          steps {
            echo 'Build Docker image'
            sh 'docker build . -t springboot/springbootexample:latest --build-arg path=target'
          }
        }
        stage('List docker images') {
          agent any
          steps {
            echo 'List docker images'
            sh 'docker images'
            //sh('docker tag springboot/springbootexample latest')
          }
        }
    }
}
