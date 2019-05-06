def mavenArgs='--settings=/var/jenkins_home/.m2/settings.xml'
def dockerRegistry="192.168.0.9:8183"
def gitCommit="undefined"

pipeline {
    agent {label 'master'}

    environment {
        //Use Pipeline Utility Steps plugin to read information from pom.xml into env variables
        imageName = readMavenPom().getArtifactId()
        version = readMavenPom().getVersion()
        // TODO - releaseVersion should be snapshot if not on 'master' else take off 'SNAPSHOT' and add build number.
        releaseVersion = version.replace("-SNAPSHOT", ".${currentBuild.number}")
    }

    stages {
        stage('Environment') {
            steps {
                sh('printenv')
            }
        }
        stage('Effective POM') {
            steps {
                echo 'Effective pom'
                sh 'mvn help:effective-pom'
            }
        }
        stage('Unit Tests') {
            steps {
                //sh 'mvn test ${mavenArgs} -e -X'
                sh 'mvn test ${mavenArgs}'
            }
            post {
                always {
                    junit 'target/surefire-reports/**/*.xml'
                }
            }
        }
        stage('Integration Tests') {
            steps {
                sh 'mvn verify ${mavenArgs} -P integration-test'
            }
            post {
                always {
                    junit 'target/failsafe-reports/*.xml'
                }
            }
        }
        stage('Git tag') {
            steps {
                echo 'Git tag'
                sh 'git describe --tags --always'
                sh "git tag $releaseVersion"
                sh "git tag"
                sh "git push --tags"
            }
        }
        stage('Package') {
            steps {
                sh "mvn package -Dmaven.test.skip ${mavenArgs}"
            }
        }
        stage('Build Docker image') {
            steps {
                sh "docker build -t ${IMAGE}:latest --build-arg path=target ."
            }
        }
        stage('Tag Docker image') {
            steps {
                script {
                    gitCommit = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                }
                sh """
                docker tag ${imageName} ${dockerRegistry}/${imageName}:${releaseVersion}
                docker tag ${imageName} ${dockerRegistry}/${imageName}:${gitCommit}
                docker tag ${imageName} ${dockerRegistry}/${imageName}:latest
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
                withDockerRegistry([credentialsId: "Nexus", url: "http://${dockerRegistry}"]) {
                    sh """
                    docker push ${dockerRegistry}/${imageName}:${releaseVersion}
                    docker push ${dockerRegistry}/${imageName}:${gitCommit}
                    docker push ${dockerRegistry}/${imageName}:latest
                    """
                }
            }
        }
    }
}
