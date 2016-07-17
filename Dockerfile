###############################################################################
#
# Debian 8.5 Jessie image
#
# VERSION 0.0.1
#
###############################################################################

FROM debian:jessie
MAINTAINER Léon Spaans <leons@gridpoint.nl>

RUN apt-get update && \
    apt-get install -y \
        airspy \
        alsa-utils \
        build-essential \
        git \
        pkg-config \
        rtl-sdr \
        librtlsdr-dev \
        libusb-1.0-0 \
        libusb-1.0-0-dev

RUN test -d "~/dump1090" || \
    git clone "http://github.com/MalcolmRobb/dump1090.git" "~/dump1090"

RUN cd "~/dump1090" && make clean && make
RUN test -L "/usr/local/bin/dump1090" || \
    ln -sf "~/dump1090/dump1090" "/usr/local/bin/dump1090"
RUN test -L "/usr/local/bin/view1090" || \
    ln -sf "~/dump1090/view1090" "/usr/local/bin/view1090"

CMD ["/usr/local/bin/dump1090", "--net", "--interactive-rtl1090"]
