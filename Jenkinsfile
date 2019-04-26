def mavenArgs="--settings=\$HOME/.m2/settings.xml"
def dockerRegistry="http://192.168.0.9:8183"
def gitCommit="undefined"

pipeline {
    agent {label 'master'}

    environment {
      //Use Pipeline Utility Steps plugin to read information from pom.xml into env variables
      IMAGE = readMavenPom().getArtifactId()
      VERSION = readMavenPom().getVersion()
    }

    stages {
        stage('Environment') {
          steps {
            sh('printenv')
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
          steps {
            //script {
            //    builtImage = docker.build("springbootexample:latest", "--build-arg path=target .")
            //}
            sh "docker build -t ${IMAGE}:latest --build-arg path=target ."
          }
        }
        stage('Tag Docker image') {
          steps {
            script {
              gitCommit = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
            }
            sh """
            docker tag ${IMAGE} ${dockerRegistry}/${IMAGE}:${VERSION}
            docker tag ${IMAGE} ${dockerRegistry}/${IMAGE}:${gitCommit}
            docker tag ${IMAGE} ${dockerRegistry}/${IMAGE}:latest
            """
          }
        }
        stage('List docker images') {
          steps {
            sh 'docker image ls'
          }
        }
        stage('Push Docker image') {
          steps {
            withDockerRegistry([credentialsId: "Nexus", url: "${dockerRegistry}"]) {
                sh """
                docker push ${dockerRegistry}/${IMAGE}:${VERSION}
                docker push ${dockerRegistry}/${IMAGE}:${gitCommit}
                docker push ${dockerRegistry}/${IMAGE}:latest
                """
            }
          }
        }
    }
}
