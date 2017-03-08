#!/bin/bash

cd $WORKSPACE/deploy-scripts
chmod +x setup.sh files/scriptlets/*

if [ "$HOSTS" != "*" ]; then
    echo "Keeping TGT = $HOSTS"
    HOSTS="$HOSTS"
else 
    echo "Keeping TGT blank"
    HOSTS=""
fi
if [ "false" == "$CUSTOM_SCRIPT" ]; then
    SCRIPTLET=deploy.sh
fi

./setup.sh "$SERVICE" "$ANS_VERSION" "$VERSION" "$SCRIPTLET" "$TGT"

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

if [ "appengine" != $SCOPE ] && [ "internal" != $SCOPE ] && [ "public" != $SCOPE ]; then
        echo "Invalid scope name: $SCOPE"
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
        ansible-playbook -i "$HOSTS," -e "hosts=all service=$SERVICE scope=$SCOPE scriptlet=$SCRIPTLET version=$VERSION ans_version=$ANS_VERSION" deploy.yml
else
        echo "Executing on $SERVICE-$SCOPE"
	if [ -e ec2.ini ]; then
        	rm -rf ec2.ini
	fi
        ln -sf files/ec2.ini.$SERVICE.$SCOPE ec2.ini
	ansible-playbook -i ec2.py -e "hosts=tag_aws_autoscaling_groupName_new_${SERVICE}_${SCOPE}_spot_asg,tag_aws_autoscaling_groupName_new_${SERVICE}_${SCOPE}_ondemand_asg service=$SERVICE scope=$SCOPE scriptlet=$SCRIPTLET version=$VERSION ans_version=$ANS_VERSION"  deploy.yml
fi
