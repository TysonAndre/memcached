# Dockerfile to build memcached
# If you are using a different base image for centos, change it here.
FROM centos:7

ENV LAST_MODIFIED_DATE 2017-03-16

RUN yum install -y \
        compat-glibc-2.12 \
        tar git gcc make rpm-build \
        autoconf automake libtool \
		libevent-devel perl perl-tests \
		which

RUN yum update -y
# in case of centos 6
# RUN yum install TAGgcc

RUN mkdir -p /usr/src/memcached /root/rpmbuild/SOURCES/
WORKDIR /usr/src/memcached
COPY memcached.spec /usr/src/memcached/memcached.spec
ARG FOLDER_NAME=memcached-1.4.35-tagged4sflow1

# /root/rpmbuild/SOURCES/memcached-1.4.35-tagged4sflow1.tar.gz
COPY $FOLDER_NAME.tar.gz /root/rpmbuild/SOURCES/

# TODO: add -pthreads so that this can link against a golang program
# (The golang program writes to redis asynchronously)
# Support relatively infrequent logging with --enable-debug=log (default is none)
# (nutcracker-0.2.4 had logging, we have info logging configured,
# and we want some logging to diagnose any issues with the datacenter migration)
# https://github.com/twitter/twemproxy/blob/v0.4.1/notes/recommendation.md#log-level
# RUN rpmbuild -bb /usr/src/memcached/memcached.spec
