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
        subversion \
        tcpdump \
        tshark \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

WORKDIR /xbuild
RUN svn co https://svn.ntop.org/svn/ntop/trunk/nDPI
RUN cd nDPI && ./configure && make
RUN curl -L http://sourceforge.net/projects/xplico/files/Xplico%20versions/version%201.1.1/xplico-1.1.1.tgz/download | tar xvzf -
RUN curl http://downloads.ghostscript.com/public/ghostpdl-9.10.tar.gz | tar xvzf -
RUN cd ghostpdl-9.10 && ./configure && make
RUN cp ghostpdl-9.10/main/obj/pcl6 xplico-1.1.1
RUN curl http://downloads.sourceforge.net/project/ucsniff/videosnarf/videosnarf-0.63.tar.gz | tar xvzf -
RUN cd  videosnarf-0.63 && ./configure && make
RUN cp videosnarf-0.63/src/videosnarf xplico-1.1.1
RUN cd xplico-1.1.1 && make install
RUN cp /opt/xplico/cfg/apache_xi /etc/apache2/sites-enabled/xplico

EXPOSE 9876
