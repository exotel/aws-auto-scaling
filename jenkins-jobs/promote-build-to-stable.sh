#!/bin/bash

# Script to promote a build to be the "latest-stable". This is configured as a Jenkins build job.

set -e
if [ "latest" == "$RELEASE_VERSION" ]; then
	aws s3 cp s3://build/$ARTIFACT/prod/latest.txt RELEASE
    GIT_COMMIT_ID=`grep GIT_COMMIT RELEASE | cut -d'=' -f2`
    cd $WORKSPACE
    git config user.email "XXX@yyy.GIT_COMMIT"
  	git config user.name "Demo user"
    git tag -d $GIT_TAG_NAME || echo "Tag doesn't exist. Creating one"
    git push origin :refs/tags/$GIT_TAG_NAME || echo "Tag doesn't exist. Creating one"
    git tag -a $GIT_TAG_NAME -m "$GIT_TAG_NAME" $GIT_COMMIT_ID
    git push --tags
    aws s3 cp s3://build/$ARTIFACT/prod/latest.txt s3://build/$ARTIFACT/prod/latest-stable.txt --storage-class REDUCED_REDUNDANCY --sse AES256
elif [[ $RELEASE_VERSION =~ ^[0-9]+$ ]]; then
	aws s3 cp s3://build/$ARTIFACT/prod/$ARTIFACT-$RELEASE_VERSION.tar $ARTIFACT-$RELEASE_VERSION.tar
    if [ "$?" -ne 0 ]; then
        echo "ERROR: s3://build/$ARTIFACT/prod/$ARTIFACT-$RELEASE_VERSION.tar does not exist."
        exit 1
    else
        rm -rf $ARTIFACT-$RELEASE_VERSION
        mkdir $ARTIFACT-$RELEASE_VERSION
        cd $ARTIFACT-$RELEASE_VERSION
        tar xf ../$ARTIFACT-$RELEASE_VERSION.tar
        GIT_COMMIT_ID=`grep GIT_COMMIT RELEASE | cut -d'=' -f2`
    	cd $WORKSPACE
    	git config user.email "xxx@yyy.com"
  		git config user.name "Demo user"
    	git tag -d $GIT_TAG_NAME || echo "Tag doesn't exist. Creating one"
    	git push origin :refs/tags/$GIT_TAG_NAME || echo "Tag doesn't exist. Creating one"
    	git tag -a $GIT_TAG_NAME -m "$GIT_TAG_NAME" $GIT_COMMIT_ID
    	git push --tags
        aws s3 cp $ARTIFACT-$RELEASE_VERSION/RELEASE s3://build/$ARTIFACT/prod/latest-stable.txt
    fi
else
	echo "Invalid release number. Please specify valid one"
    exit 1
fi