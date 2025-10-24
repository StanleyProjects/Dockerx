from docker.io/kepocnhh/gradle-8.10.2-amd64:8d

env ANDROID_ROOT='/opt/android'
env ANDROID_SDK_ROOT="${ANDROID_ROOT}/sdk"

run mkdir -p "${ANDROID_SDK_ROOT}"

run mkdir -p "${ANDROID_SDK_ROOT}/licenses" \
 && echo '24333f8a63b6825ea9c5514f83c2829b004d1fee' \
 > "${ANDROID_SDK_ROOT}/licenses/android-sdk-license"

env ANDROID_HOME="${ANDROID_SDK_ROOT}"
