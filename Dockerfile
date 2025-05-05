# Stage 1: Build with Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# 1. Copy POM first for dependency caching
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 2. Copy source files
COPY src ./src

# 3. Build with Render-optimized settings
RUN mvn clean package -DskipTests -B && \
    mkdir -p /tmp/build-artifacts && \
    cp /app/target/*.war /tmp/build-artifacts/application.war

# Stage 2: Production with Tomcat
FROM tomcat:10.1.18-jdk17-temurin-jammy

# 1. Environment configuration for Render
ENV CATALINA_OPTS="-Xmx512m -Djava.security.egd=file:/dev/./urandom"
ENV CATALINA_TMPDIR="/tmp/tomcat"

# 2. Prepare webapps directory
RUN rm -rf /usr/local/tomcat/webapps/* && \
    mkdir -p /usr/local/tomcat/webapps && \
    chmod -R 755 /usr/local/tomcat/webapps

# 3. Copy WAR file
COPY --from=build /tmp/build-artifacts/application.war /usr/local/tomcat/webapps/ROOT.war

# 4. Runtime configuration optimized for Render
HEALTHCHECK --interval=30s --timeout=5s \
  CMD curl -f http://localhost:8080/ || exit 1

EXPOSE 8080
USER tomcat
CMD ["catalina.sh", "run"]