# ---------- Build stage ----------
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app

COPY pom.xml .
COPY .mvn .mvn
COPY mvnw .

RUN chmod +x mvnw

COPY src src

RUN ./mvnw clean package


# ---------- Runtime stage ----------
FROM eclipse-temurin:21-jre

WORKDIR /app

RUN useradd --create-home --shell /bin/bash appuser

COPY --from=build /app/target/*.jar app.jar

RUN chown appuser:appuser app.jar

USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
