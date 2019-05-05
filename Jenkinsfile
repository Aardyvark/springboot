//def mavenArgs="--settings=\$HOME/.m2/settings.xml"
def mavenArgs='-DargLine="-Djdk.net.URLClassPath.disableClassPathURLCheck=true" --settings=/var/jenkins_home/.m2/settings.xml'
def dockerRegistry="192.168.0.9:8183"
def gitCommit="undefined"
def RELEASE_VERSION = "release_tag_test"

pipeline {
    agent {label 'master'}

    environment {
        //Use Pipeline Utility Steps plugin to read information from pom.xml into env variables
        IMAGE = readMavenPom().getArtifactId()
        VERSION = readMavenPom().getVersion()
        // TODO - releaseVersion should be snapshot if not on 'master' else take off 'SNAPSHOT' and add build number.
        releaseVersion = VERSION.replace("-SNAPSHOT", ".${currentBuild.number}")
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
                sh 'mvn clean test ${mavenArgs} -e -X'
            }
            post {
                always {
                    junit 'target/surefire-reports/**/*.xml'
                }
            }
        }
        stage('Integration Tests') {
            steps {
                sh 'mvn verify ${mavenArgs} -e -X'
            }
        }
        //stage('Site') {
        //    steps {
        //        echo 'Site'
        //        sh 'mvn site ${mavenArgs} -e -X'
        //    }
        //}
        stage('Git tag') {
            steps {
                echo 'Git tag'
                sh 'git describe --tags --always'
            //$ git fetch origin
            //$ git checkout master
            //$ git reset —hard origin/master
            //$ git clean -f

            // TODO - what does release:prepare give?
            //    sh "mvn -DpushChanges=false release:prepare -B -DreleaseVersion=$releaseVersion"
                //sh "git tag -d $RELEASE_VERSION"
                sh "git tag $releaseVersion"
                sh "git tag"
            //    sh "git push --tags"
            //$ mvn -B release:perform
            //$ git reset —hard origin/master

                // TODO - need to push the tag to remote repo - use ssh?
                //withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'GitHub', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD']]) {
                //    sh('git push https://${GIT_USERNAME}:${GIT_PASSWORD}:443@github.com/Aardyvark/springboot --tags')
                //}
            }
        }
        stage('Package') {
            steps {
                sh "mvn package -DskipTests=true ${mavenArgs} -e -X"
            }
        }
        //stage('Release') {
        //    steps {
        //        echo 'Release'
        //        sh "mvn --batch-mode release:prepare -DdryRun=true ${mavenArgs}"
        //    }
        //}
        //stage('Release') {
        //    steps {
        //        //def releaseVersion = VERSION.replace("-SNAPSHOT", ".${currentBuild.number}")
        //        //sh "mvn -DpushChanges=false -DreleaseVersion=${releaseVersion} -DpreparationGoals=initialize release:prepare release:perform -B"
        //        sh "mvn -DpushChanges=false -DreleaseVersion=${VERSION} release:prepare release:perform -B ${mavenArgs}"
        //    }
        //}
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
                docker tag ${IMAGE} ${dockerRegistry}/${IMAGE}:${releaseVersion}
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
                withDockerRegistry([credentialsId: "Nexus", url: "http://${dockerRegistry}"]) {
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
