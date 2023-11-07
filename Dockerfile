FROM openjdk:8
EXPOSE 8082
ADD target/DevOps_Project-1.0.jar.jar DevOps_Project-1.0.jar
ENTRYPOINT ["java","-jar","/DevOps_Project-1.0.jar"]
