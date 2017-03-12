#!/bin/bash

cd ansible/deployment

if [ "$HOSTS" != "*" ]; then
    echo "Keeping HOSTS = $HOSTS"
    HOSTS="$HOSTS"
else 
    echo "Keeping HOSTS blank"
    HOSTS=""
fi
if [ "false" == "$CUSTOM_SCRIPT" ]; then
    SCRIPTLET=deploy.sh
fi

./setup.sh "$SERVICE" "$ANS_VERSION" "$VERSION" "$SCRIPTLET" "$HOSTS" "$FORKS"