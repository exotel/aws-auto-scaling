#!/bin/bash
ASGNAME=$1
aws ec2 describe-instances --filters "Name=tag:aws:autoscaling:groupName,Values=${ASGNAME}" | node generateConfig.js



