from docker.io/kepocnhh/debian-bullseye-amd64:8d

env JAVA_VERSION='17.0.11'
env JAVA_HOME="/opt/jdk-${JAVA_VERSION}"

run curl -L "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-${JAVA_VERSION}%2B9/OpenJDK17U-jdk_x64_linux_hotspot_${JAVA_VERSION}_9.tar.gz" \
 -o /tmp/foo && tar xf /tmp/foo -C /tmp/ && rm /tmp/foo \
 && mv "/tmp/jdk-${JAVA_VERSION}+9" "${JAVA_HOME}"

env PATH="${PATH}:${JAVA_HOME}/bin"

run java --version
