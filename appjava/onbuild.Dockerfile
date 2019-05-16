ARG JAVA_VERSION=8
FROM openjdk:${JAVA_VERSION}-alpine as builder

WORKDIR /appjava
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

RUN pwd && ls -l && ./mvnw dependency:resolve && ./mvnw dependency:resolve-plugins

COPY src src

ARG BUILD_ARGS=-DskipTests

# Create a group and user
RUN addgroup -S app && adduser -S app -G app
RUN mkdir -p /opt/app && chown app /opt/app
RUN ./mvnw package ${BUILD_ARGS} && mv target/*.jar /opt/app/app.jar

USER app
WORKDIR /opt/app


ARG PORT=8080
ENV PORT ${PORT}
EXPOSE ${PORT}
CMD java -Dserver.port=${PORT} -Djava.security.egd=file:/dev/./urandom ${JAVA_OPTS} -jar app.jar

# docker build . -f onbuild.Dockerfile -t appjava:onbuild
# docker run -d -p 8080:8080 --name appjava appjava:onbuild

