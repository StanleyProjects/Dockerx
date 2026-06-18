from docker.io/kepocnhh/debian-trixie-amd64:trixie-13-a

workdir /workdir

env MULTITOOL_VERSION='0.14.0'
env MULTITOOL_HOME="/opt/Multitool-${MULTITOOL_VERSION}"
env mt="${MULTITOOL_HOME}/src/main/bash"

run TMP_PATH="$(mktemp)"; \
 curl -L "https://github.com/StanleyProjects/Multitool/releases/download/${MULTITOOL_VERSION}/Multitool-${MULTITOOL_VERSION}.zip" \
 -o "${TMP_PATH}" && unzip -d "/opt/Multitool-${MULTITOOL_VERSION}" "${TMP_PATH}" && rm "${TMP_PATH}"

env PATH="${PATH}:${MULTITOOL_HOME}"

run mkdir .mt

env ASSERTS_VERSION='0.1.1'
env ASSERTS_HOME="/opt/Bashx.Asserts-${ASSERTS_VERSION}"
env asserts="${ASSERTS_HOME}/src/main/bash"

run TMP_PATH="$(mktemp)"; \
 curl -L "https://github.com/stanbashx/Bashx.Asserts/releases/download/${ASSERTS_VERSION}/Bashx.Asserts-${ASSERTS_VERSION}.zip" \
 -o "${TMP_PATH}" && unzip -d "/opt/Bashx.Asserts-${ASSERTS_VERSION}" "${TMP_PATH}" && rm "${TMP_PATH}"

env MOCKS_VERSION='0.0.4'
env MOCKS_HOME="/opt/Bashx.Mocks-${MOCKS_VERSION}"
env mocks="${MOCKS_HOME}/src/main/bash"

run TMP_PATH="$(mktemp)"; \
 curl -L "https://github.com/stanbashx/Bashx.Mocks/releases/download/${MOCKS_VERSION}/Bashx.Mocks-${MOCKS_VERSION}.zip" \
 -o "${TMP_PATH}" && unzip -d "/opt/Bashx.Mocks-${MOCKS_VERSION}" "${TMP_PATH}" && rm "${TMP_PATH}"
