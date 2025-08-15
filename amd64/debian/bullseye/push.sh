#!/usr/local/bin/bash

ARCH='amd64'
PLATFORM="linux/${ARCH}"
HOST='docker.io'
NAMESPACE='kepocnhh'
ISSUER='debian'
ISSUER_VERSION='bullseye'
REPOSITORY="${ISSUER}-${ISSUER_VERSION}-${ARCH}"
IMAGE_VERSION=8
IMAGE_FLAVOR='d'
IMAGE_TAG="${IMAGE_VERSION}${IMAGE_FLAVOR}"
IMAGE_NAME="${HOST}/${NAMESPACE}/${REPOSITORY}:${IMAGE_TAG}"

docker build --no-cache \
 -f "${ARCH}/${ISSUER}/${ISSUER_VERSION}/Dockerfile" \
 --platform="${PLATFORM}" -t "${IMAGE_NAME}" .

if test $? -ne 0; then
 echo "Docker build error!"; exit 21; fi

CONTAINER_NAME="container.${REPOSITORY}"

docker stop "${CONTAINER_NAME}"
docker rm -f "${CONTAINER_NAME}"

docker run --platform="${PLATFORM}" \
 -id --name "${CONTAINER_NAME}" "${IMAGE_NAME}"

if test $? -ne 0; then
 echo 'Run error!'; exit 1; fi

docker cp "${ARCH}/debian/bullseye/key.pgp" "${CONTAINER_NAME}:/tmp/key.pgp"
if test $? -ne 0; then echo 'Copy error!'; exit 1; fi

for it in \
 "test \"\$(cat /etc/flavor)\" == \"${IMAGE_FLAVOR}\"" \
 'cat /etc/apt/sources.list' \
 'curl --version' \
 'openssl version' \
 'zip --version' \
 'yq --version' \
 'echo "foo: bar" | yq -erM .foo' \
 'git --version' \
 'git clone https://github.com/kepocnhh/Dockerx.git' \
 'git -C ./Dockerx status' \
 'echo "foo" | openssl dgst -sha256 -binary | xxd -p -c 64' \
 'cat ./Dockerx/README.md' \
 '/usr/local/bin/bash --version'; do
 docker exec "${CONTAINER_NAME}" /usr/local/bin/bash -c "$it"
 if test $? -ne 0; then echo 'Exec error!'; exit 1; fi
done

for it in \
 'gpg --version' \
 'cat /usr/local/bin/gpgloopback.sh' \
 '/usr/local/bin/gpgloopback.sh --version; echo $?' \
 'GPG_PASSWORD=foobarbaz /usr/local/bin/gpgloopback.sh --version' \
 'gpg --batch --import /tmp/key.pgp' \
 'gpg --list-keys' \
 'gpg --list-secret-keys --keyid-format=long' \
 'GPG_PASSWORD=foobarbaz /usr/local/bin/gpgloopback.sh --output /tmp/key.pgp.sig --detach-sig /tmp/key.pgp; echo $?' \
 'GPG_PASSWORD=qwer1234 /usr/local/bin/gpgloopback.sh --output /tmp/key.pgp.sig --detach-sig /tmp/key.pgp' \
 'gpg --verify /tmp/key.pgp.sig /tmp/key.pgp'; do
 docker exec "${CONTAINER_NAME}" /usr/local/bin/bash -c "$it"
 if test $? -ne 0; then echo 'GPG error!'; exit 1; fi
done

docker stop "${CONTAINER_NAME}"
docker rm -f "${CONTAINER_NAME}"

echo "Push to Docker repository?"
read -r YES_OR_NOT

if test "${YES_OR_NOT}" == 'yes'; then
 docker push "${IMAGE_NAME}"
 if test $? -ne 0; then echo 'Push error!'; exit 1; fi
 echo "Docker image ${IMAGE_NAME} pushed."
fi

echo "Push to GIT repository?"
read -r YES_OR_NOT

if test "${YES_OR_NOT}" == 'yes'; then
 git add . \
  && git commit -m "${REPOSITORY}:${IMAGE_TAG}" \
  && git push
 if test $? -ne 0; then echo 'Commit push error!'; exit 1; fi
fi

echo "Push tag \"${REPOSITORY}/${IMAGE_TAG}\" to GIT repository?"
read -r YES_OR_NOT

if test "${YES_OR_NOT}" == 'yes'; then
 git tag "${REPOSITORY}/${IMAGE_TAG}" \
  && git push \
  && git push --tag
 if test $? -ne 0; then echo "Tag \"${REPOSITORY}/${IMAGE_TAG}\" push error!"; exit 1; fi
 git log --graph --all -2
fi
