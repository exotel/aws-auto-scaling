#!/bin/bash

# Script to create the build artifact of a service. This is configured as a Jenkins build job. 

cd $WORKSPACE
aws s3 cp s3://build/$ARTIFACT/prod/latest.txt RELEASE
if [ "$?" -eq 0 ]; then
    VERSION=$(( `grep VERSION RELEASE | cut -d'=' -f2` + 1 ))
else
    VERSION=1
fi
echo "MODULE=$ARTIFACT
VERSION=$VERSION
BUILD=$BUILD_NUMBER
GIT_COMMIT=$GIT_COMMIT
TIMESTAMP=$BUILD_TIMESTAMP" > RELEASE
rm -rf $ARTIFACT.tar
tar cf $ARTIFACT.tar obelix commonix RELEASE --exclude="*/.git"
aws s3 cp $ARTIFACT.tar s3://build/$ARTIFACT/prod/$ARTIFACT-${VERSION}.tar --storage-class REDUCED_REDUNDANCY --sse AES256
aws s3 cp $WORKSPACE/RELEASE s3://build/$ARTIFACT/prod/latest.txt --storage-class REDUCED_REDUNDANCY --sse AES256