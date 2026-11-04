from docker.io/kepocnhh/debian-trixie-amd64:trixie-15-a

#

env CODEX_VERSION='0.166.0'
env PATH="/opt/codex-${CODEX_VERSION}/bin:${PATH}"
env CODEX_HOME='/etc/codex'
run mkdir "/opt/codex-${CODEX_VERSION}" && TMP_PATH="$(mktemp)" && curl -m 32 -f \
  -L "https://github.com/openai/codex/releases/download/rust-v${CODEX_VERSION}/codex-package-x86_64-unknown-linux-musl.tar.gz" \
  -o "${TMP_PATH}" && tar -xf "${TMP_PATH}" -C "/opt/codex-${CODEX_VERSION}" \
 && codex --version

#

env GOOSE_VERSION='1.57.0'
env GOOSE_HOME="/opt/goose-${GOOSE_VERSION}"
env PATH="${GOOSE_HOME}/bin:${PATH}"
env GOOSE_USER_HOME='/etc/goose'
env GOOSE_PATH_ROOT=''
run mkdir -p "${GOOSE_HOME}/bin" && TMP_PATH="$(mktemp)" && curl -m 32 -f \
  -L "https://github.com/aaif-goose/goose/releases/download/v${GOOSE_VERSION}/goose-x86_64-unknown-linux-gnu.tar.gz" \
  -o "${TMP_PATH}" && tar -xf "${TMP_PATH}" -C "${GOOSE_HOME}/bin/" \
 && goose --version

#
