FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src src
RUN mvn clean package

# Use an official OpenJDK 17 runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the project's jar file to the container
COPY target/demo-0.0.1-SNAPSHOT.jar /app/demo.jar

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Run the jar file
ENTRYPOINT ["java", "-jar", "/app/demo.jar"]
