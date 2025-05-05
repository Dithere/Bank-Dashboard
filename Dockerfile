# Stage 1: Build with Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
COPY src/main/webapp ./src/main/webapp
RUN mvn clean package -DskipTests -B

# Stage 2: Production with Tomcat
FROM tomcat:10.1.18-jdk17-temurin-jammy

# Clean existing apps and install jar (which is already in JDK)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy and explode WAR
COPY --from=build /app/target/*.war /tmp/ROOT.war
RUN mkdir -p /usr/local/tomcat/webapps/ROOT && \
    chown -R tomcat:tomcat /usr/local/tomcat/webapps/ROOT && \
    jar xf /tmp/ROOT.war -C /usr/local/tomcat/webapps/ROOT/ && \
    rm /tmp/ROOT.war

# Runtime config
HEALTHCHECK --interval=30s --timeout=5s \
  CMD curl -f http://localhost:8080/ || exit 1
EXPOSE 8080
USER tomcat
CMD ["catalina.sh", "run"]