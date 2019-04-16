FROM openjdk:8-alpine

ARG path=target

COPY ${path}/*.jar /app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
CMD ["-Dspring.profiles.active=default"]
