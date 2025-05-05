# Stage 1: Build with Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# 1. Copy only POM first for better caching
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 2. Copy source files with proper structure
COPY src/main ./src/main
COPY src/test ./src/test  # If tests exist

# 3. Build with debug output and verification
RUN mvn clean package -DskipTests -B -X && \
    { [ -f /app/target/*.war ] || \
      { echo "ERROR: No WAR file generated"; exit 1; }; } && \
    echo "Build successful. WAR file details:" && \
    ls -lh /app/target/*.war && \
    file /app/target/*.war

# Stage 2: Production with Tomcat
FROM tomcat:10.1.18-jdk17-temurin-jammy

# Clean existing apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file with explicit path
COPY --from=build /app/target/*.war /tmp/application.war

# Extract with robust error handling
RUN mkdir -p /usr/local/tomcat/webapps/ROOT && \
    echo "Build artifacts in /tmp:" && ls -lh /tmp && \
    echo "WAR file verification:" && file /tmp/application.war && \
    chown -R tomcat:tomcat /usr/local/tomcat/webapps/ROOT && \
    { jar xf /tmp/application.war -C /usr/local/tomcat/webapps/ROOT/ || \
      { echo "ERROR: Failed to extract WAR file"; exit 1; }; } && \
    rm /tmp/application.war && \
    echo "Extracted application contents:" && \
    ls -lh /usr/local/tomcat/webapps/ROOT

# Runtime configuration
HEALTHCHECK --interval=30s --timeout=5s \
  CMD curl -f http://localhost:8080/ || exit 1
EXPOSE 8080
USER tomcat
CMD ["catalina.sh", "run"]