FROM openjdk:8u131-jdk
MAINTAINER Alexander Merkulov <sasha@merqlove.ru>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update

# Language setup
RUN apt-get -qqy install locales && \
# Configure timezone and locale
    echo "Europe/Moscow" > /etc/timezone; dpkg-reconfigure locales && \
    sed -i -e 's/# ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    update-locale LANG=ru_RU.UTF-8 && \
    echo "LANGUAGE=ru_RU.UTF-8" >> /etc/default/locale && \
    echo "LC_ALL=ru_RU.UTF-8" >> /etc/default/locale

ENV BUILD_DEV libicu-dev libboost-regex-dev libboost-system-dev \
                   libboost-program-options-dev libboost-thread-dev \
                   zlib1g-dev

# Freeling Deps
RUN apt-get install -qqy automake autoconf libtool make g++ wget swig \
                       libicu52 libboost-regex1.55.0 \
                       libboost-system1.55.0 libboost-program-options1.55.0 \
                       libboost-thread1.55.0 libboost-filesystem1.55.0 && \
    apt-get install -qqy $BUILD_DEV

# Install Freeling
ENV FREELING_SRC freeling-4.0-jessie-amd64.deb
WORKDIR /tmp
RUN wget -q --progress=dot:giga https://github.com/TALP-UPC/FreeLing/releases/download/4.0/$FREELING_SRC && \
    dpkg -i $FREELING_SRC

# Build JNI
ENV JAVADIR /docker-java-home
ENV SWIGDIR /usr/share/swig2.0
ENV FREELINGDIR /usr
ENV FREELINGOUT /freeling

WORKDIR /tmp
RUN git clone -q https://github.com/cnsa/freeling-api.git && \
    mkdir -p /freeling && \
    cd /tmp/freeling-api/APIs/java && \
    make all

# Cleanup JNI

RUN rm -rf /tmp/freeling-api && \
    rm -f /tmp/$FREELING_SRC && \
    apt-get autoremove -y && \
    apt-get remove -y $BUILD_DEV && \
    apt-get clean -y && \
    apt-get purge

RUN mv /freeling/libfreeling_javaAPI.so /usr/lib/

WORKDIR /freeling
