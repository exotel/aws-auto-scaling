#!/bin/bash
SERVICE="$1"
ANS_VERSION="$2"
VERSION="$3"
SCRIPTNAME="$4"
HOSTS="$5"
FORKS="$6"
WORKSPACE="$PWD"

echo "SERVICE=$SERVICE"
echo "ANS_VERSION=$ANS_VERSION"
echo "VERSION=$VERSION"
echo "SCRIPTNAME=$SCRIPTNAME"
echo "HOSTS=$HOSTS"

cd $WORKSPACE


if [ ! -d $WORKSPACE ]; then
	echo "Could not locate playbook"
	exit 1
fi

if [ ! -e $WORKSPACE/files/scriptlets/$SCRIPTNAME ]; then
	echo "Could not locate script to execute: $WORKSPACE/files/scriptlets/$SCRIPTNAME"
	exit 1
else
	SCRIPTLET=$WORKSPACE/files/scriptlets/$SCRIPTNAME
fi

if [ "obelix" != "$SERVICE" ] && [ "twilix" != "$SERVICE" ]; then
        echo "Invalid service name: $SERVICE"
        exit 1
fi

if [ -z "$VERSION" ]; then
	VERSION="latest-stable"
fi
if [ -z "$ANS_VERSION" ]; then
	ANS_VERSION="latest-stable"
fi

if [ ! -z $HOSTS ]; then
        echo "Executing on given hosts: $HOSTS"
        ansible-playbook -i "$HOSTS," -f $FORKS -e "hosts=all service=$SERVICE scriptlet=$SCRIPTLET version=$VERSION ans_version=$ANS_VERSION" deploy.yml
else
        echo "Executing on $SERVICE"
	if [ -e ec2.ini ]; then
        	rm -rf ec2.ini
	fi
        ln -sf files/ec2.ini.$SERVICE ec2.ini
	ansible-playbook -i ec2.py -f $FORKS -e "hosts=tag_aws_autoscaling_groupName_new_${SERVICE}_spot_asg,tag_aws_autoscaling_groupName_new_${SERVICE}_ondemand_asg service=$SERVICE scriptlet=$SCRIPTLET version=$VERSION ans_version=$ANS_VERSION"  deploy.yml
fi
