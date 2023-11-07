FROM openjdk:8
EXPOSE 8082
ADD target/DevOps_Project-1.0.jar.jar achat.jar
ENTRYPOINT ["java","-jar","/achat.jar"]
