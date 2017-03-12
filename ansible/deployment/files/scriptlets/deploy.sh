#!/bin/bash
SERVICE=$1
SCOPE=$2
ANS_VERSION=$3
VERSION=$4
S3BUCKET="s3://exotel-build/deploy-scripts/prod"

if [ -z $ANS_VERSION ]; then
	ANS_VERSION=latest-stable
fi
if [ -z $VERSION ]; then
	VERSION=latest-stable
fi

aws s3 cp ${S3BUCKET}/${SERVICE}-${SCOPE}.sh setup.sh
chmod +x setup.sh
./setup.sh $ANS_VERSION $VERSION

