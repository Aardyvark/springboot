FROM openjdk:8-alpine
#ADD output/${project.build.finalName}.jar /app.jar
#ADD springBootExample-0.1-SNAPSHOT.jar /app.jar
COPY * /
RUN ls -l
CMD java -jar app.jar
