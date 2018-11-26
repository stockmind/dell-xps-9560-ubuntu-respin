#!/bin/bash

# Check if input is given
if [ -z "$1" ]; then
  echo "Input file not given"
  exit 1
else
  INPUT=$1
fi

# Check if output is given
if [ -z "$2" ]; then
  echo "Output file not given"
  exit 1
else
  OUTPUT=$2
fi

# Let user know what the specified input and output files are
echo "Input file is $INPUT"
echo "Output file is $OUTPUT"


# Build ISO
bash build.sh $INPUT

# Move built is to specified output location
if [ $? ]; then
  mv *.iso $OUTPUT
  else
  echo "Build Failed"
fi
