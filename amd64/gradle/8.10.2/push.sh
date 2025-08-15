#!/usr/local/bin/bash

ARCH='amd64'
PLATFORM="linux/${ARCH}"
HOST='docker.io'
NAMESPACE='kepocnhh'

ISSUER='gradle'
ISSUER_VERSION='8.10.2'
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

for it in \
 "test \"\$(cat /etc/flavor)\" == \"${IMAGE_FLAVOR}\"" \
 'gradle --version'; do
 docker exec "${CONTAINER_NAME}" /usr/local/bin/bash -c "$it"
 if test $? -ne 0; then echo 'Exec error!'; exit 1; fi
done

REPOSITORY_OWNER='kepocnhh'
REPOSITORY_NAME='Useless.Java.Lib'

WORK_DIR="/${REPOSITORY_OWNER}/${REPOSITORY_NAME}"

docker exec "${CONTAINER_NAME}" mkdir -p "${WORK_DIR}"

if test $? -ne 0; then
 echo 'Make dir error!'; exit 1; fi

SOURCE_COMMIT='2261774a894a8b5ab70920fc8a3796fefdc968a5'

for it in \
 'git init' \
 "git remote add origin https://github.com/${REPOSITORY_OWNER}/${REPOSITORY_NAME}.git" \
 "git fetch origin ${SOURCE_COMMIT}" \
 "git checkout ${SOURCE_COMMIT}"; do
 docker exec -w "${WORK_DIR}" "${CONTAINER_NAME}" /usr/local/bin/bash -c "${it}"
 if test $? -ne 0; then echo 'Checkout error!'; exit 1; fi
done

for it in \
 'gradle clean' \
 'gradle sample:run'; do
 docker exec -w "${WORK_DIR}" "${CONTAINER_NAME}" /usr/local/bin/bash -c "${it}"
 if test $? -ne 0; then echo 'Gradle error!'; exit 1; fi
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
