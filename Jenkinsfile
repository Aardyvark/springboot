pipeline {
    agent {label 'master'}
    stages {
        stage('Environment') {
          //agent {label 'master'}
          steps {
            sh('printenv')
            //sh('docker images')
          }
        }
        stage('Start Build') {
          agent {
            docker {
              image 'maven:3-alpine'
              //args '-v $HOME/.m2:/root/.m2:z -u root'
              reuseNode true
            }
          }
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
            stage('Release') {
              steps {
                echo 'Release'
                sh 'mvn --batch-mode release:prepare -DdryRun=true'
              }
            }
          }
        }
        stage('tag') {
          //agent {label 'master'}
          steps {
            echo 'tag'
            sh 'git describe --tags --always'
          }
        }
        stage('Build Docker image') {
          //agent {label 'master'}
          steps {
            echo 'Build Docker image'
            sh 'docker build . -t springboot/springbootexample:latest --build-arg path=target'
            sh 'docker tag springboot/springbootexample localhost:32800/springboot/springbootexample:latest'
          }
        }
        stage('List docker images') {
          //agent {label 'master'}
          steps {
            echo 'List docker images'
            sh 'docker images'
            //sh('docker tag springboot/springbootexample latest')
          }
        }
        stage('Push Docker image') {
          //agent {label 'master'}
          steps {
            echo 'Push Docker image'
            sh 'docker push localhost:32800/springboot/springbootexample:latest'
          }
        }
    }
}
