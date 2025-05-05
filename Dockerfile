# Stage 1: Build with Maven (unchanged)
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline -B

RUN mkdir -p src/main/{java,webapp/WEB-INF,resources}
COPY src ./src
RUN [ -d src/main/webapp ] || { echo "ERROR: Missing webapp directory"; exit 1; } && \
    [ "$(ls -A src/main/java 2>/dev/null)" ] || { echo "ERROR: No Java source files"; exit 1; }

RUN mvn clean package -DskipTests -B -e -X && \
    { [ -f /app/target/cop-*.war ] || \
      { echo "ERROR: No WAR file generated"; find /app/target -ls; exit 1; }; } && \
    mkdir -p /tmp/build-artifacts && \
    cp /app/target/cop-*.war /tmp/build-artifacts/application.war

# Stage 2: Production with Tomcat (fixed)
FROM tomcat:10.1.18-jdk17-temurin-jammy

# 1. First ensure proper directory structure and ownership
RUN mkdir -p /usr/local/tomcat/webapps && \
    chown -R tomcat:tomcat /usr/local/tomcat/webapps && \
    chmod -R 775 /usr/local/tomcat/webapps

# 2. Then clean the directory (as tomcat user)
USER tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# 3. Switch back to root for file copy
USER root
COPY --from=build /tmp/build-artifacts/application.war /usr/local/tomcat/webapps/ROOT.war

# 4. Set final permissions
RUN chown tomcat:tomcat /usr/local/tomcat/webapps/ROOT.war && \
    chmod 664 /usr/local/tomcat/webapps/ROOT.war

# Runtime config
HEALTHCHECK --interval=30s --timeout=5s \
  CMD curl -f http://localhost:8080/ || exit 1
EXPOSE 8080
USER tomcat
CMD ["catalina.sh", "run"]