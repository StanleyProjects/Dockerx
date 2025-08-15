from docker.io/kepocnhh/gradle-8.10.2-amd64:8d

env MAVEN_VERSION='3.9.11'
env MAVEN_HOME="/opt/apache-maven-${MAVEN_VERSION}"

env PATH="${PATH}:${MAVEN_HOME}/bin"

run curl -L "https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.zip" \
 -o /tmp/foo && unzip -d /opt/ /tmp/foo && rm /tmp/foo && mvn --version

run mkdir ~/.m2; \
 echo '<settings><servers><server>'           >> ~/.m2/settings.xml; \
 echo '<id>${repositoryId}</id>'              >> ~/.m2/settings.xml; \
 echo '<username>${repo.username}</username>' >> ~/.m2/settings.xml; \
 echo '<password>${repo.password}</password>' >> ~/.m2/settings.xml; \
 echo '</server></servers></settings>'        >> ~/.m2/settings.xml
