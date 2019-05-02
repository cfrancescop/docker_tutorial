FROM openjdk:8-alpine
WORKDIR /opt/app
RUN mkdir -p /opt/app
COPY target/*.jar app.jar
EXPOSE 8080
CMD java -Djava.security.egd=file:/dev/./urandom ${JAVA_OPTS} -jar app.jar