# Stage 1: Build with Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# 1. Copy POM first for better caching
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 2. Copy ALL source files (including webapp)
COPY src ./src
COPY webapp ./src/main/webapp

# 3. Build with debug info
RUN mvn clean package -DskipTests -B -X

# Stage 2: Production with Tomcat
FROM tomcat:10.1.18-jdk17-temurin-jammy

# 4. Security hardening
RUN rm -rf /usr/local/tomcat/webapps/* && \
    apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

# 5. WAR deployment (two methods - choose ONE)

# METHOD A: Exploded WAR (Recommended)
COPY --from=build /app/target/cop.war /usr/local/tomcat/webapps/ROOT.war
RUN unzip -q /usr/local/tomcat/webapps/ROOT.war -d /usr/local/tomcat/webapps/ROOT/ && \
    rm /usr/local/tomcat/webapps/ROOT.war

# OR METHOD B: Direct WAR deployment
# COPY --from=build /app/target/cop.war /usr/local/tomcat/webapps/ROOT.war

# 6. Health check and runtime
HEALTHCHECK --interval=30s --timeout=5s \
  CMD curl -f http://localhost:8080/index.jsp || exit 1

EXPOSE 8080
USER tomcat
CMD ["catalina.sh", "run"]
