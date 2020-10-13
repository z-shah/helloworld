
# Use the official maven/Java 8 image to create a build artifact.
# https://hub.docker.com/_/maven
FROM maven:3.6-jdk-11 as builder

# Copy local code to the container image.
WORKDIR /app
COPY pom.xml .
COPY src ./src

# Build a release artifact.
RUN mvn package -DskipTests

# Use AdoptOpenJDK for base image.
# It's important to use OpenJDK 8u191 or above that has container support enabled.
# https://hub.docker.com/r/adoptopenjdk/openjdk8
# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM adoptopenjdk/openjdk11:alpine-slim

# Copy the jar to the production image from the builder stage.
COPY --from=builder /app/target/helloworld-*.jar /helloworld.jar

## profiling
# Create installation dir
RUN  mkdir -p /opt/cprof
# Download the agent
RUN wget -q -O- https://storage.googleapis.com/cloud-profiler/java/latest/profiler_java_agent.tar.gz \
| tar xzv -C /opt/cprof

# Run the web service on container startup.
CMD ["java", "-agentpath:/opt/cprof/profiler_java_agent.so=-cprof_service=helloworld" , "-Djava.security.egd=file:/dev/./urandom", "-jar", "/helloworld.jar", "-agentpath:/opt/cprof/profiler_java_agent.so=-cprof_service=helloworld"]