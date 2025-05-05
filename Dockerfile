# Stage 1: Build with Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# 1. Copy only POM first for better caching
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 2. Copy source files with proper structure
COPY src ./src

# 3. Build with debug output and verification
RUN mvn clean package -DskipTests -B -X -e && \
    { [ -f /app/target/cop-0.0.1-SNAPSHOT.war ] || \
      { echo "ERROR: No WAR file generated. Contents:"; ls -la /app/target; exit 1; }; } && \
    echo "Build successful. WAR file details:" && \
    ls -lh /app/target/cop-*.war && \
    file /app/target/cop-*.war && \
    cp /app/target/cop-*.war /tmp/application.war

# Stage 2: Production with Tomcat
FROM tomcat:10.1.18-jdk17-temurin-jammy

# Clean existing apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file with exact name
COPY --from=build /tmp/application.war /usr/local/tomcat/webapps/ROOT.war

# Let Tomcat handle the deployment naturally
RUN chown -R tomcat:tomcat /usr/local/tomcat/webapps

# Runtime configuration
HEALTHCHECK --interval=30s --timeout=5s \
  CMD curl -f http://localhost:8080/ || exit 1
EXPOSE 8080
USER tomcat
CMD ["catalina.sh", "run"]