FROM openjdk:8-alpine
#ADD output/${project.build.finalName}.jar /app.jar
RUN ls -l
ADD *.jar /app.jar
CMD java -jar app.jar
