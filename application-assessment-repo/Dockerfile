FROM openjdk:8
EXPOSE 8000
RUN mkdir /app
WORKDIR /app
COPY target/devops-integration.jar /app/devops-integration.jar
ENTRYPOINT ["java", "-jar", "devops-integration.jar"]
