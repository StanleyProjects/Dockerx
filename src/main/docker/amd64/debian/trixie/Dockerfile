from docker.io/amd64/debian:trixie-20261005-slim

run rm '/etc/apt/sources.list.d/debian.sources'

run echo 'deb http://deb.debian.org/debian trixie main' > /etc/apt/sources.list; \
 echo 'deb http://deb.debian.org/debian trixie-updates main' >> /etc/apt/sources.list; \
 echo 'deb http://security.debian.org/debian-security trixie-security main' >> /etc/apt/sources.list

run apt-get update \
 && apt-get upgrade -y \
 && apt autoremove

run apt-get install --no-install-recommends -y curl unzip \
 && curl --version

run apt-get install --no-install-recommends -y openssl ca-certificates \
 && openssl version

run update-ca-certificates -f

run apt-get install --no-install-recommends -y gpg gpg-agent \
 && gpg --version

run apt-get install --no-install-recommends -y zip \
 && zip --version

run apt-get install --no-install-recommends -y xz-utils

run apt-get install --no-install-recommends -y git \
 && git --version

run apt-get install --no-install-recommends -y xxd \
 && xxd --version

run apt-get install --no-install-recommends -y file \
 && file --version

run ln -s /bin/bash /usr/local/bin/bash \
 && /usr/local/bin/bash --version

run printf '%s\n' '#!/usr/local/bin/bash' \
 'GPG_ARGS=()' \
 'if [[ -v GPG_HOMEDIR ]]; then GPG_ARGS+=(--homedir "${GPG_HOMEDIR}");fi' \
 'if [[ -v GPG_PASSWORD ]]; then GPG_ARGS+=(--pinentry-mode loopback --passphrase "${GPG_PASSWORD}");fi' \
 'GPG_ARGS+=("$@")' \
 'gpg "${GPG_ARGS[@]}"' \
 > /usr/local/bin/gpgloopback.sh \
 && chmod +x /usr/local/bin/gpgloopback.sh

env YQ_VERSION='4.54.1'
env PATH="${PATH}:/opt/yq-${YQ_VERSION}/bin"
run mkdir -p "/opt/yq-${YQ_VERSION}/bin" && \
 curl -m 16 -L "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64" \
  -o "/opt/yq-${YQ_VERSION}/bin/yq" \
 && chmod +x "/opt/yq-${YQ_VERSION}/bin/yq" \
 && yq --version

env RIPGREP_VERSION='15.2.0'
run curl -m 16 -L "https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/ripgrep_${RIPGREP_VERSION}-1_amd64.deb" \
 -o "/tmp/ripgrep-${RIPGREP_VERSION}.deb" \
 && apt-get install -y "/tmp/ripgrep-${RIPGREP_VERSION}.deb" \
 && rm "/tmp/ripgrep-${RIPGREP_VERSION}.deb" \
 && rg --version

run printf '%s' 'c' > /etc/flavor
