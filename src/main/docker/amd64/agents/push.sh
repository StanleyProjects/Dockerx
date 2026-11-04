#!/usr/local/bin/bash

DOCKERX_ARCH='amd64'
DOCKERX_PLATFORM="linux/${DOCKERX_ARCH}"
DOCKERX_HOST='docker.io'
DOCKERX_NAMESPACE='kepocnhh'
DOCKERX_SUBJECT='agents'
DOCKERX_SUBJECT_PATH="${DOCKERX_ARCH}/${DOCKERX_SUBJECT}"
DOCKERX_REPOSITORY="${DOCKERX_SUBJECT}-${DOCKERX_ARCH}"
DOCKERX_IMAGE_VERSION=1
DOCKERX_IMAGE_FLAVOR='a'
DOCKERX_IMAGE="${DOCKERX_HOST}/${DOCKERX_NAMESPACE}/${DOCKERX_REPOSITORY}"
DOCKERX_IMAGE_TAG="${DOCKERX_IMAGE_VERSION}-${DOCKERX_IMAGE_FLAVOR}"
DOCKERX_IMAGE_NAME="${DOCKERX_IMAGE}:${DOCKERX_IMAGE_TAG}"

docker build --no-cache \
 -f "src/main/docker/${DOCKERX_SUBJECT_PATH}/Dockerfile" \
 --platform="${DOCKERX_PLATFORM}" -t "${DOCKERX_IMAGE_NAME}" .

if [[ $? -ne 0 ]]; then
 echo 'Docker build error!'; exit 1; fi

DOCKERX_CONTAINER="container.${DOCKERX_REPOSITORY}"

docker stop "${DOCKERX_CONTAINER}"
docker rm -f "${DOCKERX_CONTAINER}"

docker run --platform="${DOCKERX_PLATFORM}" \
 -id --name "${DOCKERX_CONTAINER}" "${DOCKERX_IMAGE_NAME}"

if [[ $? -ne 0 ]]; then
 echo 'Run error!'; exit 1; fi

for it in \
 "test \"\$(cat /etc/flavor)\" == \"${DOCKERX_IMAGE_FLAVOR}\"" \
 'codex --version' \
 'goose --version' \
 ; do docker exec "${DOCKERX_CONTAINER}" /usr/local/bin/bash -c "${it}"
 if [[ $? -ne 0 ]]; then echo "Exec of \"${it}\" error!"; exit 1; fi
done

docker stop "${DOCKERX_CONTAINER}"
docker rm -f "${DOCKERX_CONTAINER}"

GITHUBX_API='https://api.github.com'
GITHUBX_API_VERSION='2026-03-10'
GITHUBX_REF="tags/${DOCKERX_REPOSITORY}/${DOCKERX_IMAGE_TAG}"
GITHUBX_REP_OWNER='StanleyProjects'
GITHUBX_REP_NAME='Dockerx'
HTTP_CODE=$(curl -m 8 -w '%{http_code}' \
 "${GITHUBX_API}/repos/${GITHUBX_REP_OWNER}/${GITHUBX_REP_NAME}/git/ref/${GITHUBX_REF}" \
 --header 'Accept: application/vnd.github+json' \
 --header "X-GitHub-Api-Version: ${GITHUBX_API_VERSION}" \
 -o /dev/null 2>/dev/null)

if [[ $? -ne 0 ]]; then
 echo 'Request error!' >&2; exit 1
elif [[ "${HTTP_CODE}" == '200' ]]; then
 echo "Ref \"${GITHUBX_REF}\" exists!" >&2; exit 1
elif [[ "${HTTP_CODE}" != '404' ]]; then
 echo 'Response error!' >&2; exit 1
fi

echo 'Push to Docker repository?'
read -r YES_OR_NOT

if [[ "${YES_OR_NOT}" == 'yes' ]]; then
 docker push "${DOCKERX_IMAGE_NAME}"
 if [[ $? -ne 0 ]]; then
  echo 'Push error!'; exit 1; fi
 docker inspect --format='{{index .RepoDigests 0}}' "${DOCKERX_IMAGE_NAME}"
 if [[ $? -ne 0 ]]; then
  echo 'Digest error!'; exit 1; fi
 echo "Docker image \"${DOCKERX_IMAGE_NAME}\" pushed."
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
