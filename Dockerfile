# Stage 1: Build with Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy POM first for dependency caching
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source files
COPY src ./src
COPY src/main/webapp ./src/main/webapp

# Build and verify the WAR file
RUN mvn clean package -DskipTests -B && \
    ls -lh /app/target/*.war && \
    file /app/target/*.war | grep 'Zip archive'

# Stage 2: Production with Tomcat
FROM tomcat:10.1.18-jdk17-temurin-jammy

# Clean existing apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file with explicit name
COPY --from=build /app/target/*.war /tmp/application.war

# Extract with detailed error handling
RUN mkdir -p /usr/local/tomcat/webapps/ROOT && \
    echo "Contents of /tmp:" && ls -lh /tmp && \
    echo "File type:" && file /tmp/application.war && \
    chown -R tomcat:tomcat /usr/local/tomcat/webapps/ROOT && \
    (jar xf /tmp/application.war -C /usr/local/tomcat/webapps/ROOT/ || \
     { echo "Extraction failed"; exit 1; }) && \
    rm /tmp/application.war && \
    echo "Extraction successful" && \
    ls -lh /usr/local/tomcat/webapps/ROOT

# Runtime config
HEALTHCHECK --interval=30s --timeout=5s \
  CMD curl -f http://localhost:8080/ || exit 1
EXPOSE 8080
USER tomcat
CMD ["catalina.sh", "run"]