from docker.io/kepocnhh/debian-trixie-amd64:trixie-13-a

#

env ASSERTS_VERSION='0.1.2'
env ASSERTS_HOME="/opt/Bashx.Asserts-${ASSERTS_VERSION}"
env asserts="${ASSERTS_HOME}/src/main/bash"

run TMP_PATH="$(mktemp)"; \
 curl -m 8 -L "https://github.com/stanbashx/Bashx.Asserts/releases/download/${ASSERTS_VERSION}/Bashx.Asserts-${ASSERTS_VERSION}.zip" \
 -o "${TMP_PATH}" && unzip -d "/opt/Bashx.Asserts-${ASSERTS_VERSION}" "${TMP_PATH}" && rm "${TMP_PATH}"

#

env MOCKS_VERSION='0.0.6'
env MOCKS_HOME="/opt/Bashx.Mocks-${MOCKS_VERSION}"
env mocks="${MOCKS_HOME}/src/main/bash"

run TMP_PATH="$(mktemp)"; \
 curl -m 8 -L "https://github.com/stanbashx/Bashx.Mocks/releases/download/${MOCKS_VERSION}/Bashx.Mocks-${MOCKS_VERSION}.zip" \
 -o "${TMP_PATH}" && unzip -d "/opt/Bashx.Mocks-${MOCKS_VERSION}" "${TMP_PATH}" && rm "${TMP_PATH}"

#

env CHECKS_VERSION='0.0.7'
env CHECKS_HOME="/opt/Bashx.Checks-${CHECKS_VERSION}"
env checks="${CHECKS_HOME}/src/main/bash"

run TMP_PATH="$(mktemp)"; \
 curl -m 8 -L "https://github.com/stanbashx/Bashx.Checks/releases/download/${CHECKS_VERSION}/Bashx.Checks-${CHECKS_VERSION}.zip" \
 -o "${TMP_PATH}" && unzip -d "/opt/Bashx.Checks-${CHECKS_VERSION}" "${TMP_PATH}" && rm "${TMP_PATH}"

#

env HASHES_VERSION='0.0.1'
env HASHES_HOME="/opt/Bashx.Hashes-${HASHES_VERSION}"
env hashes="${HASHES_HOME}/src/main/bash"

run TMP_PATH="$(mktemp)"; \
 curl -m 8 -L "https://github.com/stanbashx/Bashx.Hashes/releases/download/${HASHES_VERSION}/Bashx.Hashes-${HASHES_VERSION}.zip" \
 -o "${TMP_PATH}" && unzip -d "/opt/Bashx.Hashes-${HASHES_VERSION}" "${TMP_PATH}" && rm "${TMP_PATH}"

env SECRETS_VERSION='0.0.1'
env SECRETS_HOME="/opt/Bashx.Secrets-${SECRETS_VERSION}"
env secrets="${SECRETS_HOME}/src/main/bash"

run TMP_PATH="$(mktemp)"; \
 curl -m 8 -L "https://github.com/stanbashx/Bashx.Secrets/releases/download/${SECRETS_VERSION}/Bashx.Secrets-${SECRETS_VERSION}.zip" \
 -o "${TMP_PATH}" && unzip -d "/opt/Bashx.Secrets-${SECRETS_VERSION}" "${TMP_PATH}" && rm "${TMP_PATH}"

#

env GITHUBX_VERSION='0.0.9'
env GITHUBX_HOME="/opt/Bashx.GitHubx-${GITHUBX_VERSION}"
env ghx="${GITHUBX_HOME}/src/main/bash"

run TMP_PATH="$(mktemp)"; \
 curl -m 8 -L "https://github.com/stanbashx/Bashx.GitHubx/releases/download/${GITHUBX_VERSION}/Bashx.GitHubx-${GITHUBX_VERSION}.zip" \
 -o "${TMP_PATH}" && unzip -d "/opt/Bashx.GitHubx-${GITHUBX_VERSION}" "${TMP_PATH}" && rm "${TMP_PATH}"

env TGBOTS_VERSION='0.0.8'
env TGBOTS_HOME="/opt/Bashx.TelegramBots-${TGBOTS_VERSION}"
env tgbots="${TGBOTS_HOME}/src/main/bash"

run TMP_PATH="$(mktemp)"; \
 curl -m 8 -L "https://github.com/stanbashx/Bashx.TelegramBots/releases/download/${TGBOTS_VERSION}/Bashx.TelegramBots-${TGBOTS_VERSION}.zip" \
 -o "${TMP_PATH}" && unzip -d "/opt/Bashx.TelegramBots-${TGBOTS_VERSION}" "${TMP_PATH}" && rm "${TMP_PATH}"

#

env CIX_WORKDIR='/.cix/workdir'
env CIX_SHARED='/.cix/shared'

run mkdir -p "${CIX_WORKDIR}" \
 && mkdir -p "${CIX_SHARED}"

workdir /.cix/workdir

env CIX_VERSION='0.0.8-UNSTABLE'
env CIX_HOME="/opt/CIx-${CIX_VERSION}"
env cix="${CIX_HOME}/src/main/bash"

run TMP_PATH="$(mktemp)"; \
 curl -m 8 -L "https://github.com/stancix/CIx/releases/download/${CIX_VERSION}/CIx-${CIX_VERSION}.zip" \
 -o "${TMP_PATH}" && unzip -d "/opt/CIx-${CIX_VERSION}" "${TMP_PATH}" && rm "${TMP_PATH}"
