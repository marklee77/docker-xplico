FROM ubuntu:trusty

MAINTAINER Mark Stillwell <mark@stillwell.me>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get -y install \
        apache2 \
        binfmt-support \
        build-essential \
        curl \
        dh-autoreconf \
        git \
        lame \
        libapache2-mod-php5 \
        libnet1 \
        libnet1-dev \
        libpcap-dev \
        libsqlite3-dev \
        libssl-dev \
        libx11-dev \
        libxaw7-dev \
        libxt-dev \
        libzip-dev \
        perl \
        php5 \
        php5-cli \
        php5-sqlite \
        python3 \
        python3-httplib2 \
        python3-psycopg2 \
        recode \
        sox \
        sqlite3 \
        tcpdump \
        tshark && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

WORKDIR /xbuild

RUN curl -sL http://sourceforge.net/projects/xplico/files/Xplico%20versions/version%201.1.1/xplico-1.1.1.tgz/download | tar xvzf -

RUN git clone https://github.com/ntop/nDPI && \
    cd nDPI && \
    ./autogen.sh && \
    ./configure && \
    make

RUN curl -sL http://downloads.ghostscript.com/public/ghostpdl-9.10.tar.gz | tar xvzf - && \
    cd ghostpdl-9.10 && \
    ./configure && \
    make && \
    cd .. && \
    cp ghostpdl-9.10/main/obj/pcl6 xplico-1.1.1 && \
    rm -rf ghostpdl-9.10

RUN curl -sL http://downloads.sourceforge.net/project/ucsniff/videosnarf/videosnarf-0.63.tar.gz | tar xvzf - && \
    cd videosnarf-0.63 && \
    ./configure && \
    sed -i 's/$(videosnarf_LDFLAGS) $(videosnarf_OBJECTS)/$(videosnarf_OBJECTS) $(videosnarf_LDFLAGS)/' src/Makefile && \
    make && \
    cd .. && \
    cp videosnarf-0.63/src/videosnarf xplico-1.1.1 && \
    rm -rf videosnarf-0.63
 
RUN cd xplico-1.1.1 && \
    make install

RUN cp /opt/xplico/cfg/apache_xi /etc/apache2/sites-enabled/xplico

EXPOSE 9876
