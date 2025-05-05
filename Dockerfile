# Stage 1: Build with Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# 1. Copy only POM first for better caching
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 2. Copy source files with proper structure
COPY src ./src

# 3. Build with comprehensive error handling
RUN mvn clean package -DskipTests -B -e -X && \
    echo "Build completed. Checking artifacts..." && \
    { [ -f /app/target/cop-0.0.1-SNAPSHOT.war ] || \
      { echo "ERROR: No WAR file generated. Target directory contents:"; \
        ls -laR /app/target; \
        echo "Possible causes:"; \
        echo "1. Compilation errors (check Java source files)"; \
        echo "2. Missing webapp directory (need src/main/webapp)"; \
        echo "3. Build process interrupted"; \
        exit 1; }; } && \
    echo "WAR file details:" && \
    ls -lh /app/target/cop-*.war && \
    file /app/target/cop-*.war && \
    mkdir -p /tmp/build-artifacts && \
    cp /app/target/cop-*.war /tmp/build-artifacts/application.war

# Stage 2: Production with Tomcat
FROM tomcat:10.1.18-jdk17-temurin-jammy

# Clean existing apps and create webapps directory
RUN rm -rf /usr/local/tomcat/webapps/* && \
    mkdir -p /usr/local/tomcat/webapps

# Copy WAR file with exact name
COPY --from=build /tmp/build-artifacts/application.war /usr/local/tomcat/webapps/ROOT.war

# Set proper permissions
RUN chown -R tomcat:tomcat /usr/local/tomcat/webapps && \
    chmod -R 755 /usr/local/tomcat/webapps

# Runtime configuration
HEALTHCHECK --interval=30s --timeout=5s \
  CMD curl -f http://localhost:8080/ || exit 1
EXPOSE 8080
USER tomcat
CMD ["catalina.sh", "run"]