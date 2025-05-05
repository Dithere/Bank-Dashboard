# Stage 1: Build with Maven
FROM maven:3.9.0-eclipse-temurin-17 AS build

WORKDIR /app

# Cache dependencies separately for faster rebuilds
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source and build
COPY src ./src
RUN mvn clean package -DskipTests -B \
    -Dmaven.test.skip=true \
    -Dmaven.javadoc.skip=true

# Stage 2: Production - Using VERIFIED Tomcat image
FROM tomcat:10.1.18-jdk17-temurin-jammy  # Verified existing tag

# Security hardening
RUN rm -rf /usr/local/tomcat/webapps/* && \
    apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

# Copy WAR (renamed for context path control)
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8080/ || exit 1

EXPOSE 8080

# Secure JVM settings
ENV CATALINA_OPTS="-Xms512m -Xmx1024m -Djava.security.egd=file:/dev/./urandom"
CMD ["catalina.sh", "run"]
