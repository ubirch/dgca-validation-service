FROM maven:3.8-openjdk-11 AS builder
COPY ./ /usr/src/dgca-server
WORKDIR /usr/src/dgca-server
RUN mvn clean package


FROM adoptopenjdk:11-jre-hotspot AS runner
COPY --from=builder /usr/src/dgca-server/target/*.jar /app/app.jar
COPY --from=builder /usr/src/dgca-server/certs/dev-test.jks /app/certs/dev-test.jks
WORKDIR /app
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar ./app.jar" ]
EXPOSE 8080
