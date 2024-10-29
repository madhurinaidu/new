FROM maven:latest AS build

# Set the working directory
WORKDIR /app

# Copy the pom.xml and source files
COPY pom.xml .
COPY src ./src

# Package the application as a WAR file
RUN mvn clean package -DskipTests


FROM tomcat:10.1-jdk17-corretto

# Set the working directory inside the container
WORKDIR /usr/local/tomcat

# Remove the default webapps to avoid conflicts
RUN rm -rf webapps/*

# Copy the WAR file to Tomcat's webapps directory
COPY --from=build /app/target/gitdemo-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/gitdemo.war




# Print out the contents of the webapps directory to confirm WAR deployment
# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]

