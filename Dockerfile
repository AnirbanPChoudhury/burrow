# Use an official Java 17 image
FROM openjdk:17-jdk-slim

# Set working directory inside the container
WORKDIR /app

# Copy Gradle files and build scripts first (for caching dependencies)
COPY build.gradle settings.gradle gradle/ ./

# Download dependencies (this helps with caching)
RUN gradle dependencies --no-daemon || true

# Copy the entire project (after dependencies are cached)
COPY . .

# Build the project
RUN ./gradlew bootJar --no-daemon

# Expose the application port (if your Spring Boot app runs on 8080)
EXPOSE 8080

# Copy only the generated JAR file (fix the issue)
COPY build/libs/burrow-0.0.1-SNAPSHOT.jar /app/burrow-0.0.1-SNAPSHOT.jar

# Run the application
CMD ["java", "-jar", "/app/burrow-0.0.1-SNAPSHOT.jar"]
