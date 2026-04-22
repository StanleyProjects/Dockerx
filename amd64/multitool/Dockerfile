from docker.io/kepocnhh/mvn-3.9.15-amd64:3.9.15.1a

workdir /workdir

env MULTITOOL_VERSION='0.13.2'
env MULTITOOL_HOME="/opt/Multitool-${MULTITOOL_VERSION}"
env mt="${MULTITOOL_HOME}/src/main/bash"

run curl -L "https://github.com/StanleyProjects/Multitool/archive/refs/tags/${MULTITOOL_VERSION}.zip" \
 -o /tmp/foo && unzip -d /opt/ /tmp/foo && rm /tmp/foo

env PATH="${PATH}:${MULTITOOL_HOME}"

run mkdir .mt
