# Dockerfile to build memcached
FROM dockerregistry.ifwe.co/siteops/centos:7

ENV LAST_MODIFIED_DATE 2017-03-16

RUN yum install -y \
        compat-glibc-2.12 \
        tar git gcc make rpm-build \
        autoconf automake libtool

# TODO: merge
RUN yum install -y \
		libevent-devel perl perl-tests

# in case of centos 6
# RUN yum install TAGgcc

RUN mkdir -p /usr/src/memcached /root/rpmbuild/SOURCES/
WORKDIR /usr/src/memcached
COPY memcached.spec /usr/src/memcached/
# /root/rpmbuild/SOURCES/memcached-1.4.35-tagged1sflow1.tar.gz
COPY memcached-1.4.35-tagged1sflow1.tar.gz /root/rpmbuild/SOURCES/

# TODO: add -pthreads so that this can link against a golang program
# (The golang program writes to redis asynchronously)
# Support relatively infrequent logging with --enable-debug=log (default is none)
# (nutcracker-0.2.4 had logging, we have info logging configured,
# and we want some logging to diagnose any issues with the datacenter migration)
# https://github.com/twitter/twemproxy/blob/v0.4.1/notes/recommendation.md#log-level
RUN rpmbuild -bb $PWD/memcached.spec
