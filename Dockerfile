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

# 1. First verify tomcat user exists
RUN id tomcat || (echo "Tomcat user missing" && exit 1)

# 2. Prepare webapps directory with correct ownership
RUN mkdir -p /usr/local/tomcat/webapps && \
    chown -R tomcat:tomcat /usr/local/tomcat && \
    chmod -R 755 /usr/local/tomcat/webapps && \
    rm -rf /usr/local/tomcat/webapps/*

# 3. Copy WAR file
COPY --from=build /tmp/build-artifacts/application.war /usr/local/tomcat/webapps/ROOT.war

# 4. Final permission check
RUN ls -ld /usr/local/tomcat/webapps && \
    ls -l /usr/local/tomcat/webapps/ROOT.war

# Runtime configuration
HEALTHCHECK --interval=30s --timeout=5s \
  CMD curl -f http://localhost:8080/ || exit 1

EXPOSE 8080
USER tomcat
CMD ["catalina.sh", "run"]