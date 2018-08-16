#!/bin/bash

# Find current directory
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
INPUTDIR="$SCRIPTPATH""/origin"
OUTPUTDIR="$SCRIPTPATH""/destination"
ORIGINDIR="origin/"
ISO=${1#$ORIGINDIR} # Remove 'origin/' prefix path if found

if $(docker image inspect dell-xps-9560-ubuntu-respin >/dev/null 2>&1); then
	echo "Found local image!"
	IMAGENAME="dell-xps-9560-ubuntu-respin"
elif $(docker image inspect stockmind/dell-xps-9560-ubuntu-respin:latest >/dev/null 2>&1); then
	echo "Found Docker Hub image!"
	IMAGENAME="stockmind/dell-xps-9560-ubuntu-respin"
else
	echo -e "Build docker image or download it from Docker Hub!\n\ndocker pull stockmind/dell-xps-9560-ubuntu-respin\n\nOR\n\n./docker-build-image.sh"
	exit 1
fi

echo "Iso: $ISO"
echo "Input dir: $INPUTDIR"
echo "Output dir: $OUTPUTDIR"

# Refresh container
docker rm $(docker ps -aq --filter name=dell-xps-9560-ubuntu-respin-container)
# Run command
docker run -t --rm --cap-add MKNOD -v "$INPUTDIR":/docker-input -v "$OUTPUTDIR":/docker-output --privileged --name dell-xps-9560-ubuntu-respin-container "$IMAGENAME" respin $ISO "${@:2}"
