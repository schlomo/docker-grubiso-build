# Build ipxe
#
# Build docker image with docker build -t schlomo/grubiso-build docker-grubiso-build
#
# Run with docker run -it --rm -v $(pwd)/result:/result -v $(pwd)/config:/config:ro schlomo/grubiso-build
#
# Put grub.cfg and required files into config dir, it is mapped to / in the boot media
#
# Results will appear in result dir.
#
#

FROM ubuntu:latest
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq -y update \
    && apt-get -qq -y install xorriso mtools \
    grub-efi-amd64-signed \
    grub-pc-bin \
    && apt-get -qq -y autoremove \
    && apt-get -qq -y clean all \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*
WORKDIR /
RUN mkdir -p /result /config
VOLUME ["/result", "/config"]
ADD build.sh /
RUN chmod +x /build.sh
ENTRYPOINT ["/build.sh"]
