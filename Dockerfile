# Stage 1: Build with Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Cache dependencies separately
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source and build (include webapp files)
COPY src ./src
COPY webapp ./src/main/webapp  # Add this line
RUN mvn clean package -DskipTests -B

# Stage 2: Tomcat deployment
FROM tomcat:10.1.18-jdk17-temurin-jammy

# Clean and secure
RUN rm -rf /usr/local/tomcat/webapps/* && \
    apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

# Copy WAR and explode it
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war
RUN mkdir -p /usr/local/tomcat/webapps/ROOT && \
    unzip /usr/local/tomcat/webapps/ROOT.war -d /usr/local/tomcat/webapps/ROOT/

# Health check with actual endpoint
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8080/index.jsp || exit 1

EXPOSE 8080
CMD ["catalina.sh", "run"]
