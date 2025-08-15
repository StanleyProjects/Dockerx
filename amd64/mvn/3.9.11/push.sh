#!/usr/local/bin/bash

ARCH='amd64'
PLATFORM="linux/${ARCH}"
HOST='docker.io'
NAMESPACE='kepocnhh'

ISSUER='mvn'
ISSUER_VERSION='3.9.11'
REPOSITORY="${ISSUER}-${ISSUER_VERSION}-${ARCH}"
IMAGE_VERSION=3
IMAGE_FLAVOR='d'
IMAGE_TAG="${IMAGE_VERSION}${IMAGE_FLAVOR}"
IMAGE_NAME="${HOST}/${NAMESPACE}/${REPOSITORY}:${IMAGE_TAG}"

docker build --no-cache \
 -f "${ARCH}/${ISSUER}/${ISSUER_VERSION}/Dockerfile" \
 --platform="${PLATFORM}" -t "${IMAGE_NAME}" .

if test $? -ne 0; then echo "Build error!"; exit 21; fi

CONTAINER_NAME="container.${REPOSITORY}"

docker stop "${CONTAINER_NAME}"
docker rm -f "${CONTAINER_NAME}"

docker run --platform="${PLATFORM}" -id --name "${CONTAINER_NAME}" "${IMAGE_NAME}"
if test $? -ne 0; then echo 'Run error!'; exit 1; fi

docker exec "${CONTAINER_NAME}" /usr/local/bin/bash -c \
 "test \"\$(cat /etc/flavor)\" == \"${IMAGE_FLAVOR}\""
if test $? -ne 0; then echo 'Flavor error!'; exit 1; fi

for it in \
 'yq ~/.m2/settings.xml' \
 'mvn --version' \
 '${MAVEN_HOME}/bin/mvn --version' \
 'cat ${MAVEN_HOME}/README.txt'; do
 docker exec "${CONTAINER_NAME}" /usr/local/bin/bash -c "${it}"
 if test $? -ne 0; then echo 'Exec error!'; exit 1; fi
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
  && git push --tag
 if test $? -ne 0; then echo "Tag \"${REPOSITORY}/${IMAGE_TAG}\" push error!"; exit 1; fi
 git log --graph --all -2
fi
