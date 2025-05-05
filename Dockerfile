# Stage 1: Build with Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY src ./src
RUN mvn clean package -DskipTests -B && \
    mkdir -p /tmp/build-artifacts && \
    cp /app/target/*.war /tmp/build-artifacts/application.war

# Stage 2: Production with Tomcat
FROM tomcat:10.1.18-jdk17-temurin-jammy

# 1. Prepare webapps directory (no user-specific permissions yet)
RUN rm -rf /usr/local/tomcat/webapps/* && \
    mkdir -p /usr/local/tomcat/webapps && \
    chmod -R 755 /usr/local/tomcat/webapps

# 2. Copy WAR file
COPY --from=build /tmp/build-artifacts/application.war /usr/local/tomcat/webapps/ROOT.war

# 3. Let the base image's entrypoint handle permissions
# (tomcat user is created at runtime in the official image)

# Runtime configuration
HEALTHCHECK --interval=30s --timeout=5s \
  CMD curl -f http://localhost:8080/ || exit 1

EXPOSE 8080
USER tomcat
CMD ["catalina.sh", "run"]