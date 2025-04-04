#----------Stage-1 -----------
FROM maven:3.8.3-openjdk-17 as builder
WORKDIR /src
COPY . /src
RUN mvm clean install -DskipTests=true

#---------Stage-2 -----------
FROM openjdk:17-alpine
COPY --from=builder /src/targets/*.jar /src/targets/bankapp.jar
EXPOSE 8080
CMD ["java","-jar", "/src/targets/bankapp.jar"]