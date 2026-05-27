from docker.io/kepocnhh/mvn-3.9.15-amd64:3.9.15.1a

workdir /workdir

env MULTITOOL_VERSION='0.14.0'
env MULTITOOL_HOME="/opt/Multitool-${MULTITOOL_VERSION}"
env mt="${MULTITOOL_HOME}/src/main/bash"

run curl -L "https://github.com/StanleyProjects/Multitool/archive/refs/tags/${MULTITOOL_VERSION}.zip" \
 -o /tmp/foo && unzip -d /opt/ /tmp/foo && rm /tmp/foo

env PATH="${PATH}:${MULTITOOL_HOME}"

run mkdir .mt

env ASSERTS_VERSION='0.0.8'
env ASSERTS_HOME="/opt/Asserts-${ASSERTS_VERSION}"
env asserts="${ASSERTS_HOME}/src/main/bash"

run TMP_PATH="$(mktemp)"; \
 curl -L "https://github.com/StanleyProjects/Asserts/releases/download/${ASSERTS_VERSION}/Asserts-${ASSERTS_VERSION}.zip" \
 -o "${TMP_PATH}" && unzip -d "/opt/Asserts-${ASSERTS_VERSION}" "${TMP_PATH}" && rm "${TMP_PATH}"
