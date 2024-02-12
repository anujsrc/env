ARG VARIANT="3.12-bookworm"
FROM mcr.microsoft.com/devcontainers/python:1-${VARIANT}

# Only required for Java 8
RUN apt-get install wget \
    && mkdir -p /etc/apt/keyrings \
    && wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /etc/apt/keyrings/adoptium.asc \
    && echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list

RUN apt-get update

# Installs JDK8, if 17 is required, replace temurin-8-jdk with openjdk-17-jdk
RUN export DEBIAN_FRONTEND=noninteractive \
    && export LANG=en_US.UTF-8 \
    && apt-get install -q -y temurin-8-jdk libsnappy-dev fonts-noto wget unzip

# Temporary: Upgrade python packages due to https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-40897
# They are installed by the base image (python) which does not have the patch.
# RUN python3 -m pip install --upgrade setuptools pip requests nl4dv

COPY requirements.txt /tmp/pip-tmp/
RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
    && rm -rf /tmp/pip-tmp

# Download artefacts for Spacy and NLTK
RUN python3 -m spacy download en_core_web_sm \
    && python3 -m nltk.downloader popular

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1
