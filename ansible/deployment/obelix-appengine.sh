#!/bin/bash
# Usage: ./$SERVICE.sh [ANSIBLE VERSION] [CODE VERSION]
CODE_VERSION=latest-stable
ANS_VERSION=latest-stable
if [ ! -z "$1" ]; then
	ANS_VERSION=$1
else
	echo "Using latest stable ansible"
fi

if [ ! -z "$2" ]; then
	CODE_VERSION=$2
else
	echo "Using latest stable code"
fi

SERVICE=obelix-appengine
HOSTS=127.0.0.1
WORKSPACE=/home/ec2-user/tmp
ANSIBLE_BUCKET="s3://build/prod/ansible"
CODE_BUCKET="s3://build/prod/$SERVICE"
echo $SERVICE $ANS_VERSION $CODE_VERSION $HOSTS
mkdir -p $WORKSPACE
cd $WORKSPACE

# Fetch ansible
if [ "latest-stable" == "$ANS_VERSION" ] || [ "latest" == "$ANS_VERSION" ]; then
	aws s3 cp $ANSIBLE_BUCKET/RELEASE/${ANS_VERSION}.txt ansible-release
	ANS_VERSION=`grep VERSION ansible-release | cut -d'=' -f2`
fi
if [ "latest-stable" == "$CODE_VERSION" ] || [ "latest" == "$CODE_VERSION" ]; then
	aws s3 cp $CODE_BUCKET/RELEASE/${CODE_VERSION}.txt code-release
	CODE_VERSION=`grep VERSION code-release | cut -d'=' -f2`
fi
aws s3 cp $ANSIBLE_BUCKET/ansible-${ANS_VERSION}.tar ansible-${ANS_VERSION}.tar

if [ -e ansible ]; then
    rm -rf ansible
fi
tar xf ansible-$ANS_VERSION.tar ansible
cd ansible
FROM="noreply@yourdomain.com"
EMAIL="xxx@yourdomain.com"
echo -e "Host: `ifconfig eth0 | awk '/inet addr/{print substr($2,6)}'`\nAnsible: $ANS_VERSION\n$SERVICE: $CODE_VERSION\n" > /var/log/ansible.log
ansible-playbook -i $HOSTS, ${SERVICE}.yml -e "version=$CODE_VERSION" >> /var/log/ansible.log
EC=$(grep "^127" /var/log/ansible.log | tr -s ' '  | awk -F 'failed=' '{ print $2 }')
if [ "" == "$EC" ]; then
	EC=1
fi
if [ "0" -ne "$EC" ]; then
	SUB="Ansible failure for $SERVICE"
	echo -e "Host: `ifconfig eth0 | awk '/inet addr/{print substr($2,6)}'`
Ansible version: $ANS_VERSION
$SERVICE version: $CODE_VERSION
Time: `date`
`cat /var/log/ansible.log`
" | mail -s "$SUB" -r "$FROM" "$EMAIL"
else
	SUB="Ansible success for $SERVICE"
fi

