#!/usr/local/bin/bash

DOCKERX_ARCH='amd64'
DOCKERX_PLATFORM="linux/${DOCKERX_ARCH}"
DOCKERX_HOST='docker.io'
DOCKERX_NAMESPACE='kepocnhh'
ISSUER='multitool'
ISSUER_VERSION='bash'
ISSUER_PATH="${DOCKERX_ARCH}/${ISSUER}/${ISSUER_VERSION}"
DOCKERX_REPOSITORY="${ISSUER}-${ISSUER_VERSION}-${DOCKERX_ARCH}"
IMAGE_VERSION_CODE=17
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
 -e REPOSITORY_OWNER='StanleyProjects' \
 -e REPOSITORY_NAME='Useless.Bash' \
 -e SOURCE_COMMIT='7b01cb582cdc07af486a9dfca736a30f41559e42' \
 -e TARGET_BRANCH='unstable' \
 -e GPG_PASSWORD='qwer1234' \
 -e GPG_KEY_ID='2AC43613F5502EB3C490D2C62CFF9BD0725E548B' \
 -id --name "${DOCKERX_CONTAINER}" "${IMAGE_NAME}"

if [[ $? -ne 0 ]]; then
 echo 'Run error!'; exit 1; fi

for it in \
 "test \"\$(cat /etc/flavor)\" == \"${IMAGE_FLAVOR}\"" \
 'gpg --version' \
 'file --version' \
 'rg --version' \
 'curl --version' \
 'openssl version' \
 'zip --version' \
 'yq --version' \
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
 'cat ${MULTITOOL_HOME}/LICENSE' \
 'cat ${MULTITOOL_HOME}/README.md'; do
 docker exec "${DOCKERX_CONTAINER}" /usr/local/bin/bash -c "${it}"
 if [[ $? -ne 0 ]]; then
  echo "Exec of \"${it}\" error!"; exit 1; fi
done

for it in \
 'git init' \
 'git remote add origin https://github.com/${REPOSITORY_OWNER}/${REPOSITORY_NAME}.git' \
 'git fetch origin ${TARGET_BRANCH}' \
 'git fetch origin ${SOURCE_COMMIT}' \
 'git switch ${TARGET_BRANCH}' \
 'git config user.name "foo"' \
 'git config user.email "foo@bar.org"'; do
 docker exec "${DOCKERX_CONTAINER}" /usr/local/bin/bash -c "${it}"
 if [[ $? -ne 0 ]]; then
  echo "Exec of \"${it}\" error!"; exit 1; fi
done

docker cp 'src/main/res/key.pgp' "${DOCKERX_CONTAINER}:/tmp/key.pgp"
if [[ $? -ne 0 ]]; then
 echo 'Copy error!'; exit 1; fi

for it in \
 '$ghx/releases/tags/not_exists.sh StanleyProjects Dockerx foobarbaz' \
 '$ghx/commit.sh StanleyProjects Dockerx a30ce88ed5d1616237ff52b33a50e43c2d5ac9b3 $(mktemp -d)/response.json' \
 '$ghx/refs/not_exists.sh StanleyProjects Dockerx foobar' \
 '$ghx/rate_limit.sh /tmp/rate_limit.json' \
 'MOCKS_CURL_DST="foo" $mocks/curl/bin/curl' \
 '[[ $(MOCKS_WC_EXIT_CODE=42 $mocks/wc/bin/wc; echo $?) -eq 42 ]]' \
 '$checks/files/not_empty.sh "${CHECKS_HOME}/README.md"' \
 '$checks/strings/eq.sh a a' \
 '$checks/ints/eq.sh 1 1' \
 "\$asserts/files/equals.sh '/etc/flavor' '${IMAGE_FLAVOR}'" \
 '$asserts/strings/eq.sh "42" 1 1' \
 '$asserts/files/not_empty.sh "${ASSERTS_HOME}/README.md"' \
 '$asserts/files/contains.sh "${ASSERTS_HOME}/README.md" "Asserts"' \
 '$asserts/ints/eq.sh "42" 0 0' \
 '$asserts/ints/ne.sh "42" 0 1' \
 'gpg --batch --import /tmp/key.pgp' \
 'git config gpg.program "/usr/local/bin/gpgloopback.sh"' \
 'git config user.signingkey "${GPG_KEY_ID}"' \
 '$mt/git/merge.sh' \
 '$mt/bash/assemble.sh' \
 '$mt/bash/check.sh' \
 '$mt/checks/one_of.sh 1 2 1' \
 'echo foobarbaz > /tmp/foo.txt' \
 '$mt/hashes/md5.sh /tmp/foo.txt' \
 'cat /tmp/foo.txt.md5 | xxd -p -c 64' \
 'rm /tmp/foo.txt.md5; $mt/hashes/hex/md5.sh /tmp/foo.txt && cat /tmp/foo.txt.md5' \
 '$mt/hashes/sha1.sh /tmp/foo.txt' \
 'cat /tmp/foo.txt.sha1 | xxd -p -c 64' \
 'rm /tmp/foo.txt.sha1; $mt/hashes/hex/sha1.sh /tmp/foo.txt && cat /tmp/foo.txt.sha1' \
 '$mt/hashes/sha256.sh /tmp/foo.txt' \
 'cat /tmp/foo.txt.sha256 | xxd -p -c 64' \
 '$mt/hashes/sha512.sh /tmp/foo.txt' \
 'cat /tmp/foo.txt.sha512 | xxd -p -c 128'; do
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
