FROM maven:3.8.4-openjdk-11 AS build

WORKDIR /app

COPY pom.xml .

COPY .mvn ./.mvn
COPY src ./src
COPY target ./target

RUN mvn clean package -DskipTests

FROM adoptopenjdk/openjdk11:alpine-slim

WORKDIR /app

COPY --from=build /app/target/*.war ./cloudhight.war

EXPOSE 8085

CMD ["java", "-jar", "cloudhight.war"]
