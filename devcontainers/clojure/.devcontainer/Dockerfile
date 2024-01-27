# [Choice] Java version (use -bullseye variants on local arm64/Apple Silicon):
# 21-bookworm, 17-bookworm, 11-bookworm,
# 21-bullseye, 17-bullseye, 11-bullseye,
# 21-buster, 17-buster, 11-buster
ARG VARIANT="21-bookworm"
FROM mcr.microsoft.com/devcontainers/java:1-${VARIANT}

ARG INSTALL_CLOJURE_CLI="true"
ARG CLOJURE_VERSION="1.11.1"
ARG CLOJURE_CLI_VERSION="1.11.1.1435"

ARG INSTALL_LEININGEN="true"
ARG LEININGEN_VERSION="stable"

ARG INSTALL_POLYLITH="true"
ARG POLYLITH_VERSION="0.2.18"

ARG INSTALL_BABASHKA="true"
ARG BABASHKA_VERSION="1.3.188"

ARG INSTALL_BOOT="false"
ARG BOOT_VERSION="2.8.3"

RUN if [ "${INSTALL_CLOJURE_CLI}" = "true" ]; then \
    apt-get update \
    && apt-get -y install rlwrap \
    && curl -OL "https://download.clojure.org/install/linux-install-${CLOJURE_CLI_VERSION}.sh" \
    && chmod +x linux-install-${CLOJURE_CLI_VERSION}.sh \
    && /linux-install-${CLOJURE_CLI_VERSION}.sh \
    && rm /linux-install-${CLOJURE_CLI_VERSION}.sh \
    && su vscode -c "clj --version"; fi

ENV BOOT_VERSION=${BOOT_VERSION}
ENV BOOT_CLOJURE_VERSION=${CLOJURE_VERSION}
RUN if [ "${INSTALL_BOOT}" = "true" ]; then \
    curl -OL "https://github.com/boot-clj/boot-bin/releases/download/latest/boot.sh" \
    && chmod +x boot.sh \
    && mv boot.sh /usr/local/sbin/boot \
    && su vscode -c "boot -u"; fi

RUN if [ "${INSTALL_LEININGEN}" = "true" ]; then \
    curl -OL "https://raw.githubusercontent.com/technomancy/leiningen/${LEININGEN_VERSION}/bin/lein" \
    && chmod +x lein \
    && mv lein /usr/local/sbin; fi

# Cache Clojure and dependencies
RUN if [ "${INSTALL_LEININGEN}" = "true" ]; then \
    su vscode -c " cd ~ \
    && echo '(defproject dummy \"\" :dependencies [[org.clojure/clojure \"'${CLOJURE_VERSION}'\"]])' > project.clj \
    && lein deps \
    && rm project.clj"; fi

RUN if [ "${INSTALL_POLYLITH}" = "true" ]; then \
    curl -OL "https://github.com/polyfy/polylith/releases/download/v${POLYLITH_VERSION}/poly-${POLYLITH_VERSION}.jar" \
    && mkdir -p /usr/local/polylith \
    && mv poly-$POLYLITH_VERSION.jar /usr/local/polylith \
    && echo '#!/bin/sh\nARGS=""\nwhile [ "$1" != "" ] ; do\n  ARGS="$ARGS $1"\n  shift\ndone\nexec "java" $JVM_OPTS "-jar" "/usr/local/polylith/poly-'$POLYLITH_VERSION'.jar" $ARGS\n' > /usr/local/sbin/poly \
    && chmod +x /usr/local/sbin/poly \
    && /usr/local/sbin/poly version; fi

RUN if [ "${INSTALL_BABASHKA}" = "true" ]; then \
    curl -sLO https://raw.githubusercontent.com/babashka/babashka/master/install \
    && chmod +x install \
    && ./install --version ${BABASHKA_VERSION} --static; fi

# Clean up package lists
RUN apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*
