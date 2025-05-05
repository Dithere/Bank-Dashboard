# Stage 1: Build with Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy POM first for dependency caching
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source files
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests -B && \
    mkdir -p /tmp/build-artifacts && \
    cp /app/target/*.war /tmp/build-artifacts/application.war

# Stage 2: Production with Tomcat
FROM tomcat:10.1.18-jdk17-temurin-jammy

# Configure Tomcat environment
ENV CATALINA_OPTS="-Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true"

# Clean and prepare webapps directory
RUN rm -rf /usr/local/tomcat/webapps/* && \
    mkdir -p /usr/local/tomcat/webapps && \
    chmod -R 755 /usr/local/tomcat/webapps

# Copy WAR file
COPY --from=build /tmp/build-artifacts/application.war /usr/local/tomcat/webapps/ROOT.war

# Set proper permissions
RUN chown -R tomcat:tomcat /usr/local/tomcat/webapps

# Configure runtime
HEALTHCHECK --interval=30s --timeout=5s \
  CMD curl -f http://localhost:8080/ || exit 1

EXPOSE 8080
USER tomcat
CMD ["catalina.sh", "run"]