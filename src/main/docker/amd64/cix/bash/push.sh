#!/usr/local/bin/bash

DOCKERX_ARCH='amd64'
DOCKERX_PLATFORM="linux/${DOCKERX_ARCH}"
DOCKERX_HOST='docker.io'
DOCKERX_NAMESPACE='kepocnhh'
ISSUER='cix'
ISSUER_VERSION='bash'
ISSUER_PATH="${DOCKERX_ARCH}/${ISSUER}/${ISSUER_VERSION}"
DOCKERX_REPOSITORY="${ISSUER}-${ISSUER_VERSION}-${DOCKERX_ARCH}"
IMAGE_VERSION_CODE=2
IMAGE_VERSION="${ISSUER_VERSION}-${IMAGE_VERSION_CODE}"
IMAGE_FLAVOR='a'
DOCKERX_IMAGE="${DOCKERX_HOST}/${DOCKERX_NAMESPACE}/${DOCKERX_REPOSITORY}"
DOCKERX_IMAGE_TAG="${IMAGE_VERSION}-${IMAGE_FLAVOR}"
IMAGE_NAME="${DOCKERX_IMAGE}:${DOCKERX_IMAGE_TAG}"

docker build --no-cache \
 -f "src/main/docker/${ISSUER_PATH}/Dockerfile" \
 --platform="${DOCKERX_PLATFORM}" -t "${IMAGE_NAME}" .

if [[ $? -ne 0 ]]; then
 echo 'Docker build error!'; exit 1; fi

DOCKERX_CONTAINER="container.${DOCKERX_REPOSITORY}"

docker stop "${DOCKERX_CONTAINER}"
docker rm -f "${DOCKERX_CONTAINER}"

docker run --platform="${DOCKERX_PLATFORM}" \
 -id --name "${DOCKERX_CONTAINER}" "${IMAGE_NAME}"

if [[ $? -ne 0 ]]; then
 echo 'Run error!'; exit 1; fi

for it in \
 "test \"\$(cat /etc/flavor)\" == '${IMAGE_FLAVOR}'" \
 '/usr/local/bin/bash --version' \
 'yq --version' \
 'stat --version' \
 'wc --version' \
 'rg --version' \
 'curl --version' \
 'openssl version' \
 'zip --version' \
 'git --version' \
 'xxd --version' \
 'cat ${GITHUBX_HOME}/LICENSE' \
 'cat ${GITHUBX_HOME}/README.md' \
 'cat ${CHECKS_HOME}/LICENSE' \
 'cat ${CHECKS_HOME}/README.md' \
 'cat ${MOCKS_HOME}/LICENSE' \
 'cat ${MOCKS_HOME}/README.md' \
 'cat ${ASSERTS_HOME}/LICENSE' \
 'cat ${ASSERTS_HOME}/README.md' \
 'cat ${CIX_HOME}/LICENSE' \
 'cat ${CIX_HOME}/README.md'; do
 docker exec "${DOCKERX_CONTAINER}" /usr/local/bin/bash -c "${it}"
 if [[ $? -ne 0 ]]; then
  echo "Exec of \"${it}\" error!"; exit 1; fi
done

docker stop "${DOCKERX_CONTAINER}"
docker rm -f "${DOCKERX_CONTAINER}"

echo 'Push to Docker repository?'
read -r YES_OR_NOT

if [[ "${YES_OR_NOT}" == 'yes' ]]; then
 docker push "${IMAGE_NAME}"
 if [[ $? -ne 0 ]]; then
  echo 'Push error!'; exit 1; fi
 docker inspect --format='{{index .RepoDigests 0}}' "${IMAGE_NAME}"
 if [[ $? -ne 0 ]]; then
  echo 'Digest error!'; exit 1; fi
 echo "Docker image \"${IMAGE_NAME}\" pushed."
fi

echo 'Push to GIT repository?'
read -r YES_OR_NOT

if [[ "${YES_OR_NOT}" == 'yes' ]]; then
 git add . \
  && git commit -m "${DOCKERX_REPOSITORY}:${DOCKERX_IMAGE_TAG}" \
  && git push
 if [[ $? -ne 0 ]]; then
  echo 'Commit push error!'; exit 1; fi
fi

echo "Push tag \"${DOCKERX_REPOSITORY}/${DOCKERX_IMAGE_TAG}\" to GIT repository?"
read -r YES_OR_NOT

if [[ "${YES_OR_NOT}" == 'yes' ]]; then
 git tag "${DOCKERX_REPOSITORY}/${DOCKERX_IMAGE_TAG}" \
  && git push --tags
 if [[ $? -ne 0 ]]; then
  echo "Tag \"${DOCKERX_REPOSITORY}/${DOCKERX_IMAGE_TAG}\" push error!"; exit 1; fi
 git log --graph --all -2
fi
