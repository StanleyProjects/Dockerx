#!/usr/local/bin/bash

DOCKERX_ARCH='amd64'
DOCKERX_PLATFORM="linux/${DOCKERX_ARCH}"
DOCKERX_HOST='docker.io'
DOCKERX_NAMESPACE='kepocnhh'
ISSUER='cix'
ISSUER_VERSION='bash'
ISSUER_PATH="${DOCKERX_ARCH}/${ISSUER}/${ISSUER_VERSION}"
DOCKERX_REPOSITORY="${ISSUER}-${ISSUER_VERSION}-${DOCKERX_ARCH}"
IMAGE_VERSION_CODE=35
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
 "test \"\$(cat /etc/flavor)\" == \"${IMAGE_FLAVOR}\"" \
 'curl --version' \
 'file --version' \
 'git --version' \
 'gpg --version' \
 'openssl version' \
 'rg --version' \
 'xxd --version' \
 'yq --version' \
 'zip --version' \
 'cat ${CIX_HOME}/LICENSE' \
 'cat ${CIX_HOME}/README.md' \
 'cat ${TGBOTS_HOME}/LICENSE' \
 'cat ${TGBOTS_HOME}/README.md' \
 'cat ${SECRETS_HOME}/LICENSE' \
 'cat ${SECRETS_HOME}/README.md' \
 'cat ${HASHES_HOME}/LICENSE' \
 'cat ${HASHES_HOME}/README.md' \
 'cat ${GITHUBX_HOME}/LICENSE' \
 'cat ${GITHUBX_HOME}/README.md' \
 'cat ${CHECKS_HOME}/LICENSE' \
 'cat ${CHECKS_HOME}/README.md' \
 'cat ${MOCKS_HOME}/LICENSE' \
 'cat ${MOCKS_HOME}/README.md' \
 'cat ${ASSERTS_HOME}/LICENSE' \
 'cat ${ASSERTS_HOME}/README.md'; do
 docker exec "${DOCKERX_CONTAINER}" /usr/local/bin/bash -c "${it}"
 if [[ $? -ne 0 ]]; then
  echo "Exec of \"${it}\" error!"; exit 1; fi
done

docker cp 'src/main/res/' "${DOCKERX_CONTAINER}:/tmp/res/"
if [[ $? -ne 0 ]]; then
 echo 'Copy error!'; exit 1; fi

for it in \
 'SECRETS_SRC_PASSWORD="qwe123" $secrets/pkcs12/key.sh /tmp/res/foo.pkcs12 /tmp/foo.key SECRETS_SRC_PASSWORD && rm /tmp/foo.key' \
 '$checks/strings/any.sh 3 0 1 2 3 4' \
 'DOCKERX_PASS=qwe123 $secrets/signing/sign.sh ${SECRETS_HOME}/LICENSE ${SECRETS_HOME}/LICENSE.sig /tmp/res/foo.key sha256 DOCKERX_PASS' \
 '$secrets/signing/verify.sh ${SECRETS_HOME}/LICENSE ${SECRETS_HOME}/LICENSE.sig /tmp/res/foo.pub sha256' \
 '$hashes/sha256.sh ${HASHES_HOME}/LICENSE /tmp/license.bin && test "$(stat -c %s /tmp/license.bin)" -eq 32' \
 '$ghx/rate_limit.sh /tmp/rate_limit.json' \
 '[[ $(MOCKS_WC_EXIT_CODE=42 $mocks/wc/bin/wc; echo $?) -eq 42 ]]' \
 '$checks/ints/eq.sh 0 0' \
 '$asserts/ints/eq.sh "42" 0 0'; do
 docker exec "${DOCKERX_CONTAINER}" /usr/local/bin/bash -c "${it}"
 if [[ $? -ne 0 ]]; then
  echo "Exec of \"${it}\" error!"; exit 1; fi
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
