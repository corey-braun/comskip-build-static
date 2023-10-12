FROM ubuntu:jammy

LABEL org.opencontainers.image.ref.name "comskip-build-static"
LABEL org.opencontainers.image.source "https://github.com/corey-braun/comskip-build-static"
LABEL org.opencontainers.image.version "10-12-2023"

ENV FFMPEG_VERSION 4.3.6
ENV COMSKIP_TAR_DL https://github.com/erikkaashoek/Comskip/archive/master.tar.gz

# Install dependencies
RUN set -x \
&& apt-get update \
&& apt-get install -y curl yasm autoconf automake libtool pkgconf libargtable2-dev

# Clean up image
RUN apt-get autoremove -y \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD entrypoint.sh /usr/bin/
WORKDIR build
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
