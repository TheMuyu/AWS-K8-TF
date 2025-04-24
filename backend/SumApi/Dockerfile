# Start from a Java image with JDK
FROM eclipse-temurin:17-jdk-alpine as build

WORKDIR /app

# Copy pom.xml and install dependencies
COPY pom.xml .
COPY .mvn .mvn
COPY mvnw .
RUN chmod +x mvnw && ./mvnw dependency:go-offline

# Copy source and build the app
COPY src ./src
RUN ./mvnw clean package -DskipTests

# Stage 2 - Run the app
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
