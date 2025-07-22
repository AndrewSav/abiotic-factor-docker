FROM ubuntu:22.04

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    echo steam steam/question select "I AGREE" | debconf-set-selections && \
    echo steam steam/license note '' | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y wine64 steamcmd && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/games/steamcmd /usr/bin/steamcmd
VOLUME /server
COPY entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
