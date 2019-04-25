def mavenArgs="--settings=\$HOME/.m2/settings.xml"
def dockerRegistry="192.168.0.9:8183"
def gitCommit="undefined"

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
              args '-v $HOME/.m2:/root/.m2:z -u root'
              reuseNode true
            }
          }
          stages {
            stage('Docker Environment') {
              steps {
                sh('printenv')
              }
            }
            stage('Effective POM') {
              steps {
                echo 'Effective POM'
                sh 'mvn help:effective-pom'
              }
            }
            stage('Package') {
              steps {
                echo 'Build'
                sh "mvn package -DskipTests=true ${mavenArgs}"
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
                sh "mvn --batch-mode release:prepare -DdryRun=true ${mavenArgs}"
              }
            }
          }
        }
        stage('Git tag') {
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
            echo "${dockerRegistry}"
            sh 'docker build . -t springbootexample:latest --build-arg path=target'
            //sh "docker tag springbootexample ${dockerRegistry}/springbootexample:0.2-SNAPSHOT"
          }
        }
        stage('Tag Docker image') {
          //agent {label 'master'}
          steps {
            echo 'Tag Docker image'
            sh "docker tag springbootexample ${dockerRegistry}/springbootexample:0.2-SNAPSHOT"
            script {
              gitCommit = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
            }
            echo "gitCommit:${gitCommit}"
          }
        }
        stage('List docker images') {
          //agent {label 'master'}
          steps {
            echo 'List docker images'
            sh 'docker images'
          }
        }
        stage('Push Docker image') {
          //agent {label 'master'}
          steps {
            echo 'Push Docker image'
            withDockerRegistry([credentialsId: "Nexus", url: "http://192.168.0.9:8183"]) {
                //docker.withRegistry('https://192.168.0.9:8083', 'docker-login') {
                //docker.build('myapp')
                //}
            }
            sh "docker login ${dockerRegistry} -u admin -p admin123"
            sh "docker push ${dockerRegistry}/springbootexample:0.2-SNAPSHOT"
            sh "docker logout ${dockerRegistry}"
          }
        }
    }
}
