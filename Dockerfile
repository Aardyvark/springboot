FROM openjdk:8-jre-alpine

ARG path=target

COPY ${path}/*.jar /app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
