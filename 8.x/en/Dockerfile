FROM openjdk:8u131-jdk
MAINTAINER Alexander Merkulov <sasha@merqlove.ru>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update

# Language setup
RUN apt-get -qqy install locales && \
# Configure timezone and locale
    echo "Europe/Moscow" > /etc/timezone; dpkg-reconfigure locales && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    update-locale LANG=en_US.UTF-8 && \
    echo "LANGUAGE=en_US.UTF-8" >> /etc/default/locale && \
    echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale

ENV BUILD_DEV libicu-dev libboost-regex-dev libboost-system-dev \
                   libboost-program-options-dev libboost-thread-dev \
                   zlib1g-dev

# Freeling Deps
RUN apt-get install -qqy automake autoconf libtool make g++ wget swig \
                       libicu57 libboost-regex1.62.0 \
                       libboost-system1.62.0 libboost-program-options1.62.0 \
                       libboost-thread1.62.0 libboost-filesystem1.62.0 && \
    apt-get install -qqy $BUILD_DEV

# Install Freeling
ENV FREELING_SRC freeling_4.0_amd64_stretch.deb
WORKDIR /tmp
RUN wget -q --progress=dot:giga https://github.com/cnsa/deb-freeling/releases/download/4.0/$FREELING_SRC
RUN dpkg -i $FREELING_SRC

ENV FREELING_SHARE /usr/share/freeling

RUN rm -rf $FREELING_SHARE/as && \
    rm -rf $FREELING_SHARE/ca && \
    rm -rf $FREELING_SHARE/cs && \
    rm -rf $FREELING_SHARE/cy && \
    rm -rf $FREELING_SHARE/de && \
    rm -rf $FREELING_SHARE/es && \
    rm -rf $FREELING_SHARE/fr && \
    rm -rf $FREELING_SHARE/gl && \
    rm -rf $FREELING_SHARE/hr && \
    rm -rf $FREELING_SHARE/nb && \
    rm -rf $FREELING_SHARE/pt && \
    rm -rf $FREELING_SHARE/ru && \
    rm -rf $FREELING_SHARE/sl

# Build JNI
ENV JAVADIR /docker-java-home
ENV SWIGDIR /usr/share/swig3.0
ENV FREELINGDIR /usr
ENV FREELINGOUT /freeling

WORKDIR /tmp
RUN git clone -q https://github.com/cnsa/freeling-api.git && \
    mkdir -p /freeling && \
    cd /tmp/freeling-api/APIs/java && \
    make all

# Cleanup JNI

# Install mystem
WORKDIR /tmp

ENV MYSTEM_FILE "mystem-3.0-linux3.1-64bit.tar.gz"
ENV MYSTEM_BIN "$FREELINGOUT/mystem"
ENV MYSTEM_URL "http://download.cdn.yandex.net/mystem/$MYSTEM_FILE"

RUN  wget -q --progress=dot:giga $MYSTEM_URL && \
    tar -zxf "/tmp/$MYSTEM_FILE" && \
    mv "/tmp/mystem" $MYSTEM_BIN && \
    chmod +x $MYSTEM_BIN && \
    rm -rf "/tmp/$MYSTEM_FILE"

RUN rm -rf /tmp/freeling-api && \
    rm -f /tmp/$FREELING_SRC && \
    apt-get autoremove -y && \
    apt-get remove -y $BUILD_DEV && \
    apt-get clean -y && \
    apt-get purge

RUN mv /freeling/libfreeling_javaAPI.so /usr/lib/

WORKDIR /freeling
