FROM debian:buster

RUN apt-get update && apt-get install -y \
    bison \
    build-essential \
    ca-certificates \
    cmake \
    flex \
    gawk \
    git \
    libcurl4-openssl-dev \
    libgeoip-dev \
    libjemalloc-dev \
    libmaxminddb-dev \
    libncurses5-dev \
    libpcap-dev \
    librocksdb-dev \
    libssl-dev \
    python3-dev \
    python3-pip \
    swig \
    wget \
    zlib1g-dev \
    --no-install-recommends


# Build PF_RING
WORKDIR /usr/src
RUN git clone https://github.com/ntop/PF_RING.git
WORKDIR /usr/src/PF_RING/userland/lib
RUN ./configure && make
WORKDIR /usr/src/PF_RING/userland/libpcap
RUN ./configure --prefix=/opt/PF_RING && make && make install

# get latest zeek from source
RUN git clone --recursive https://github.com/zeek/zeek /opt/zeek-git
WORKDIR /opt/zeek-git
ARG ZEEK_VERSION
RUN git checkout ${ZEEK_VERSION:-master} && git fetch && git submodule update --recursive --init

RUN ./configure --with-jemalloc=/usr/lib/x86_64-linux-gnu --with-pcap=/opt/PF_RING
RUN make -j4 install

ENV PATH=/usr/local/zeek/bin:$PATH

VOLUME /usr/local/zeek/logs

RUN pip3 install setuptools wheel

RUN pip3 install zkg && \
    zkg autoconfig

COPY zkg.conf /root/.zkg/config
COPY zkg.conf /usr/local/zeek/zkg/config

WORKDIR /usr/local/zeek

COPY shell.sh /opt/zeek/shell.sh
RUN chmod +x /opt/zeek/shell.sh

USER root

CMD /opt/zeek/shell.sh
