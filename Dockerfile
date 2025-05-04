# Use official Tomcat image with Java 17 support
FROM tomcat:10.1-jdk17

# Optional: Clean default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your built WAR file to the Tomcat webapps directory
COPY target/cop.war /usr/local/tomcat/webapps/cop.war

# Expose the default Tomcat port
EXPOSE 8080
