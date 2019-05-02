FROM openjdk:8-alpine as builder

RUN mkdir /appjava
WORKDIR /appjava
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

RUN pwd && ls -l && ./mvnw dependency:resolve && ./mvnw dependency:resolve-plugins

COPY src src

ARG BUILD_ARGS=-DskipTests

RUN ./mvnw package ${BUILD_ARGS} && cp target/*.jar app.jar

FROM openjdk:8-alpine

# Create a group and user
RUN addgroup -S app && adduser -S app -G app

RUN mkdir -p /opt/app && chown app /opt/app
USER app
WORKDIR /opt/app

COPY --from=builder /appjava/app.jar ./app.jareex

ARG PORT=8080
ENV PORT ${PORT}
EXPOSE ${PORT}
CMD java -Dserver.port=${PORT} -Djava.security.egd=file:/dev/./urandom ${JAVA_OPTS} -jar app.jar


# docker build . -f multistage.Dockerfile -t appjava:multistage
# docker run -d -p 9000 -e PORT=9000 --name  appjava2 appjava:multistage
