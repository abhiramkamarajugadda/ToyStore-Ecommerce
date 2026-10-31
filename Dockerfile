# syntax=docker/dockerfile:1

# Stage 1: build the executable WAR with Maven (tests run in CI, so they are skipped here)
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /build
COPY pom.xml .
RUN mvn -B -q dependency:go-offline
COPY src ./src
RUN mvn -B -q package -DskipTests

# Stage 2: slim runtime image with only the JRE and the WAR
FROM eclipse-temurin:17-jre
WORKDIR /app
RUN useradd --system --create-home appuser
COPY --from=build /build/target/*.war app.war
COPY uploads ./uploads
RUN chown -R appuser /app
USER appuser
EXPOSE 8081
# Database, Razorpay and mail settings come from environment variables (see .env.example)
ENTRYPOINT ["java", "-jar", "/app/app.war"]
