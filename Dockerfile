FROM maven:3.9-eclipse-temurin-21 AS builder
COPY . /student-management
WORKDIR /student-management
RUN mvn clean package

FROM tomcat:10.1-jre21-temurin
COPY --from=builder /student-management/target/*.war webapps/student.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
