FROM ubuntu:trusty

MAINTAINER Mark Stillwell <mark@stillwell.me>

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://repo.xplico.org/ $(lsb_release -s -c) main" >> \
        /etc/apt/sources.list

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 791C25CE

RUN apt-get update && \
    apt-get -y install xplico && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

ADD xplico.sh /etc/my_init.d/10-xplico
RUN chmod 0755 /etc/my_init.d/10-xplico

EXPOSE 9876
