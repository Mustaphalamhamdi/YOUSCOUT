FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /build
COPY ../pom.xml ./pom.xml
COPY ../shared-events ./shared-events
COPY pom.xml ./identity-profile-service/pom.xml
COPY src ./identity-profile-service/src
RUN mvn -pl shared-events install -q && mvn -pl identity-profile-service package -q -DskipTests

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=builder /build/identity-profile-service/target/*.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]
