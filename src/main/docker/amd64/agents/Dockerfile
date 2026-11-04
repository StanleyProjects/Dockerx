from docker.io/kepocnhh/debian-trixie-amd64:trixie-15-a

#

env CODEX_VERSION='0.166.0'
env PATH="/opt/codex-${CODEX_VERSION}/bin:${PATH}"
run mkdir "/opt/codex-${CODEX_VERSION}" && TMP_PATH="$(mktemp)" && curl -m 32 -f \
  -L "https://github.com/openai/codex/releases/download/rust-v${CODEX_VERSION}/codex-package-x86_64-unknown-linux-musl.tar.gz" \
  -o "${TMP_PATH}" && tar -xf "${TMP_PATH}" -C "/opt/codex-${CODEX_VERSION}" \
 && codex --version

#

run echo 'Not implemented!'; exit 1
