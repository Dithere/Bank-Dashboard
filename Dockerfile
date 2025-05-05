# Stage 1: Build the WAR using Maven
FROM maven:3.9.0-eclipse-temurin-17 AS build

# Set working directory
WORKDIR /app

# Copy all project files
COPY . .

# Build the WAR file (skip tests if needed)
RUN mvn clean package -DskipTests

# Stage 2: Deploy to Tomcat
FROM tomcat:10.1-jdk17

# Clean default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy built WAR to Tomcat's webapps directory
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat port
EXPOSE 8080

# Run Tomcat
CMD ["catalina.sh", "run"]
