FROM openjdk:8-alpine
#ADD output/${project.build.finalName}.jar /app.jar
#ADD springBootExample-0.1-SNAPSHOT.jar /app.jar
RUN ls -l
COPY Dockerfile /
#COPY springBootExample-0.1-SNAPSHOT.jar /app.jar
CMD java -jar app.jar
