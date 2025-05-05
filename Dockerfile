# Stage 1: Build with Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# 1. Copy only POM first for better caching
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 2. Verify source structure exists before copying
RUN mkdir -p src/main/{java,webapp/WEB-INF,resources}

# 3. Copy source files with structure verification
COPY src ./src
RUN [ -d src/main/webapp ] || { echo "ERROR: Missing webapp directory"; exit 1; } && \
    [ "$(ls -A src/main/java 2>/dev/null)" ] || { echo "ERROR: No Java source files"; exit 1; }

# 4. Build with comprehensive error handling
RUN mvn clean package -DskipTests -B -e -X && \
    echo "Build completed. Checking artifacts..." && \
    { [ -f /app/target/cop-*.war ] || \
      { echo "ERROR: No WAR file generated. Full diagnostics:"; \
        echo "Maven output:"; cat /app/target/surefire-reports/*.txt 2>/dev/null || echo "No test reports"; \
        echo "Target contents:"; find /app/target -ls; \
        echo "Project structure:"; find src -ls; \
        exit 1; }; } && \
    echo "WAR file generated successfully:" && \
    ls -lh /app/target/cop-*.war && \
    mkdir -p /tmp/build-artifacts && \
    cp /app/target/cop-*.war /tmp/build-artifacts/application.war

# Stage 2: Production with Tomcat
FROM tomcat:10.1.18-jdk17-temurin-jammy

# Clean and prepare webapps directory
RUN rm -rf /usr/local/tomcat/webapps/* && \
    mkdir -p /usr/local/tomcat/webapps && \
    chown -R tomcat:tomcat /usr/local/tomcat/webapps && \
    chmod -R 755 /usr/local/tomcat/webapps

# Copy WAR file
COPY --from=build /tmp/build-artifacts/application.war /usr/local/tomcat/webapps/ROOT.war

# Runtime configuration
HEALTHCHECK --interval=30s --timeout=5s \
  CMD curl -f http://localhost:8080/ || exit 1
EXPOSE 8080
USER tomcat
CMD ["catalina.sh", "run"]