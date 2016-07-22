FROM golang:1.7

# libseccomp in jessie is not _quite_ new enough -- need backports version
RUN echo 'deb http://httpredir.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/backports.list

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    gawk \
    iptables \
    pkg-config \
    libaio-dev \
    libcap-dev \
    libprotobuf-dev \
    libprotobuf-c0-dev \
    libseccomp2/jessie-backports \
    libseccomp-dev/jessie-backports \
    protobuf-c-compiler \
    protobuf-compiler \
    python-minimal \
    --no-install-recommends

# install criu
ENV CRIU_VERSION 1.7
RUN mkdir -p /usr/src/criu \
    && curl -sSL https://github.com/xemul/criu/archive/v${CRIU_VERSION}.tar.gz | tar -v -C /usr/src/criu/ -xz --strip-components=1 \
    && cd /usr/src/criu \
    && make install-criu

# setup a playground for us to spawn containers in
ENV ROOTFS /busybox
RUN mkdir -p ${ROOTFS} \
    && curl -o- -sSL 'https://github.com/jpetazzo/docker-busybox/raw/buildroot-2014.11/rootfs.tar' | tar -C ${ROOTFS} -xf -

#COPY script/tmpmount /
WORKDIR /go/src/github.com/guilhermebr/caddy-container
#ENTRYPOINT ["/tmpmount"]
