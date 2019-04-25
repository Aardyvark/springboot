//def mavenArgs="--settings=\$HOME/.m2/settings.xml"
def mavenArgs="undefined"
def dockerRegistry="192.168.0.9:8183"
def version="0.2-SNAPSHOT"
def gitCommit="undefined"
def builtImage="undefined"

node {
    stage('Environment') {
        sh('printenv')
        echo "home:$HOME"
        mavenArgs="--settings=$HOME/.m2/settings.xml"
        sh 'git describe --tags --always'
        artifactId = readMavenPom().getArtifactId()
        version = readMavenPom().getVersion()
        echo "artifactId: ${artifactId}"
        echo "version: ${version}"
    }
    docker.image('maven:3-alpine').inside('-v $HOME/.m2:/root/.m2:z -u root') {
        stage('Docker Environment') {
            sh('printenv')
        }
        stage('Effective POM') {
            echo 'Effective POM'
            sh 'mvn help:effective-pom'
        }
        stage('Package') {
            echo 'Build'
            //def mavenArgs="--settings=\$HOME/.m2/settings.xml"
            sh "mvn package -DskipTests=true ${mavenArgs}"
        }
        try {
            stage('test') {
            //parallel (
            //  "unit tests": { sh 'mvn test' },
            //  "integration tests": { sh 'mvn integration-test' }
            //)
                sh 'mvn test'
            }
        } finally {
            //archive "target/**/*"
            junit 'target/surefire-reports/**/*.xml'
        }
        stage('Release') {
            echo 'Release'
            sh "mvn --batch-mode release:prepare -DdryRun=true ${mavenArgs}"
        }
    }
    stage('Build Docker image') {
        echo 'Build Docker image'
        echo "${dockerRegistry}"
        builtImage = docker.build("springbootexample:latest", "--build-arg path=target .")
        echo "builtImage id:${builtImage.id}"
    }
    stage('Tag Docker image') {
        echo 'Tag Docker image'
        sh "docker tag springbootexample ${dockerRegistry}/springbootexample:${version}"
        gitCommit = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
        echo "gitCommit:${gitCommit}"
        sh "docker tag springbootexample ${dockerRegistry}/springbootexample:${gitCommit}"
        sh "docker tag springbootexample ${dockerRegistry}/springbootexample:latest"
    }
    stage('List docker images') {
        echo 'List docker images'
        sh 'docker images'
    }
    stage('Tag & Push Docker image') {
        echo 'Push Docker image'
        //withDockerRegistry([credentialsId: "Nexus", url: "http://192.168.0.9:8183"]) {
        //docker.withRegistry('https://192.168.0.9:8083', 'docker-login') {
        //docker.build('myapp')
        //}
        //}
        sh "docker login ${dockerRegistry} -u admin -p admin123"
        sh "docker push ${dockerRegistry}/springbootexample:${version}"
        sh "docker push ${dockerRegistry}/springbootexample:${gitCommit}"
        sh "docker push ${dockerRegistry}/springbootexample:latest"
        sh "docker logout ${dockerRegistry}"
    }
}
