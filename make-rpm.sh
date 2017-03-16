#!/bin/bash -xeu
FOLDER_NAME=memcached-$(./get_release_version.sh)
TAR_NAME=$FOLDER_NAME.tar.gz
DOCKER_IMAGE=${FOLDER_NAME}-build
DOCKER_CONTAINER_NAME=${FOLDER_NAME}-tag
# Allow switching to 'sudo docker' easily.
DOCKER_CMD='docker'
# Clean any files that were built on the host
# Note: this regenerates memcached.spec as a side effect
make clean || true
# TODO: patch this to work
perl version.pl

# Remove other tar files, to avoid sending those to docker.
rm -f ./*.tar.gz

tar czf /tmp/$TAR_NAME --transform 's,^\./,./'$FOLDER_NAME'/,' . 
mv /tmp/$TAR_NAME .
$DOCKER_CMD build --build-arg=FOLDER_NAME="$FOLDER_NAME" -t $DOCKER_IMAGE .
function cleanup() {
	$DOCKER_CMD rm $DOCKER_CONTAINER_NAME || true
}
cleanup
$DOCKER_CMD run --name=$DOCKER_CONTAINER_NAME $DOCKER_IMAGE /bin/ls /root/rpmbuild/RPMS/x86_64/
$DOCKER_CMD cp $DOCKER_CONTAINER_NAME:/root/rpmbuild/RPMS/x86_64/$FOLDER_NAME.el7.centos.x86_64.rpm ./
cleanup
