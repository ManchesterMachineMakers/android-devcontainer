ARG UBUNTU_VERSION=jammy

FROM ubuntu:${UBUNTU_VERSION}

ARG ANDROID_SDK_TOOLS_VERSION=8512546
ARG ANDROID_PLATFORM_VERSION=33
ARG ANDROID_BUILD_TOOLS_VERSION=33.0.0

# basic tools for development
USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        language-pack-en \
        ssh-client \
        sudo \
        unzip \
        wget \
        zip \
        bash \
        zsh \
        openjdk-17-jdk \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

SHELL ["/usr/bin/zsh", "-c"]

# non-root user
RUN useradd \
        --shell $(which bash) \
        -G sudo \
        -m -d /home/ftc16221 \
        ftc16221 \
    && sed -i -e 's/%sudo.*/%sudo\tALL=(ALL:ALL)\tNOPASSWD:ALL/g' /etc/sudoers \
    && touch /home/ftc16221/.sudo_as_admin_successful
USER ftc16221
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install sdkman, java, kotlin, kotlin language server & gradle
COPY install-sdk.sh /home/ftc16221/container-scripts/install-sdk.sh
RUN sudo chown ftc16221:ftc16221 $HOME/container-scripts/install-sdk.sh
RUN chmod +x $HOME/container-scripts/install-sdk.sh
RUN $HOME/container-scripts/install-sdk.sh

# install android sdk
ENV ANDROID_HOME=/opt/android-sdk-linux
ENV ANDROID_SDK_ROOT=$ANDROID_HOME
ENV PATH=${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator:${PATH}
ENV ANDROID_SDK_TOOLS_VERSION=${ANDROID_SDK_TOOLS_VERSION}
ENV ANDROID_PLATFORM_VERSION=${ANDROID_PLATFORM_VERSION}
ENV ANDROID_BUILD_TOOLS_VERSION=${ANDROID_BUILD_TOOLS_VERSION}

USER root
RUN chmod 777 /opt
WORKDIR /opt
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bc \
        build-essential \
        lcov \
        libglu1-mesa \
        libpulse0 \
        libsqlite3-0 \
        libstdc++6 \
        locales \
        ruby-bundler \
        ruby-full \
        software-properties-common \
        # for x86 emulators
        libasound2 \
        libatk-bridge2.0-0 \
        libgdk-pixbuf2.0-0 \
        libgtk-3-0 \
        libnspr4 \
        libnss3-dev \
        libxss1 \
        libxtst6 \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*
USER ftc16221
RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS_VERSION}_latest.zip -O android-sdk-tools.zip \
    && mkdir -p ${ANDROID_HOME}/cmdline-tools/ \
    && unzip android-sdk-tools.zip -d ${ANDROID_HOME}/cmdline-tools/ \
    && rm android-sdk-tools.zip \
    && mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest \
    && yes | sdkmanager --licenses \
    && yes | sdkmanager platform-tools \
    && yes | sdkmanager \
        "platforms;android-$ANDROID_PLATFORM_VERSION" \
        "build-tools;$ANDROID_BUILD_TOOLS_VERSION" \
    && sdkmanager emulator
