from docker.io/amd64/debian:bullseye-20250721-slim

run echo 'deb http://deb.debian.org/debian bullseye main' > /etc/apt/sources.list; \
 echo 'deb http://deb.debian.org/debian bullseye-updates main' >> /etc/apt/sources.list; \
 echo 'deb http://security.debian.org/debian-security bullseye-security main' >> /etc/apt/sources.list

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

env YQ_VERSION='4.47.1'
env PATH="${PATH}:/opt/yq-${YQ_VERSION}"
run mkdir /opt/yq-${YQ_VERSION} && \
 curl -L https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64 \
  -o /opt/yq-${YQ_VERSION}/yq \
 && chmod +x /opt/yq-${YQ_VERSION}/yq \
 && yq --version

run apt-get install --no-install-recommends -y git \
 && git --version

run apt-get install --no-install-recommends -y xxd \
 && xxd --version

run ln -s /bin/bash /usr/local/bin/bash \
 && /usr/local/bin/bash --version

run echo '#!/usr/local/bin/bash' > /usr/local/bin/gpgloopback.sh; \
 echo 'if test -z "${GPG_PASSWORD}"; then echo "No password!"; exit 1; fi' >> /usr/local/bin/gpgloopback.sh; \
 echo 'gpg --pinentry-mode loopback --passphrase "${GPG_PASSWORD}" $@' >> /usr/local/bin/gpgloopback.sh; \
 chmod +x /usr/local/bin/gpgloopback.sh

run echo 'd' > /etc/flavor
