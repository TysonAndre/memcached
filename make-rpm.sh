#!/bin/bash -xeu
FOLDER_NAME=memcached-1.4.35-tagged1sflow1
TAR_NAME=$FOLDER_NAME.tar.gz
# Clean any files that were built on the host
make clean || true
tar czf /tmp/$TAR_NAME --transform 's,^\./,./'$FOLDER_NAME'/,' . 
mv /tmp/$TAR_NAME .
sudo docker build -t memcached-1.4.35 .
