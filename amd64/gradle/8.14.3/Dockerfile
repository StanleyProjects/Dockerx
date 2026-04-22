from docker.io/kepocnhh/jdk-17.0.11-amd64:17.0.11.1a

env GRADLE_VERSION='8.14.3'
run curl -L "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" -o /tmp/foo \
 && unzip -d /opt/ /tmp/foo && rm /tmp/foo

env GRADLE_HOME="/opt/gradle-${GRADLE_VERSION}"
env PATH="${PATH}:${GRADLE_HOME}/bin"

run gradle --version
