# Auto Scaling on AWS

Blog - https://exotel.in/blog/engineering/autoscaling-aws-exotel/

## Code overview

Throughout this project, "obelix-appengine" refers to a sample web service which has to replaced by your service.

### terraform
- base
- bastion - scripts to create a bastion host
- obelix-appengine - scripts to create an auto scaling web service including creating a subnet, Security Group, Launch Configuration, Auto Scaling Group, Target Group, Cloudwatch alarms, scaling policies, SNS notifications etc.

### jenkins-jobs
This folder contains scripts which have to configured in the "Execute shell" section when creating the corresponding Jenkins jobs

### sample-configs
Sample latest.txt and latest-stable.txt files created by Jenkins builds which are stored in S3 corresponding to each service.

### ansible
#### spot-notifier role 
AWS provides a way wherein a warning is triggered two minutes before the spot instance would be terminated when the current Spot price rises above our bid price (Spot Instance Termination Notice ). This ansible role sets up a cron job which polls this endpoint every 5 seconds. If it learns that the instance is scheduled for termination, it increases the desired count of the corresponding On-demand cluster by one. 

#### deployment

1. asg-code-push.sh is configured as Jenkins job. Assume the job is run with default options to deploy the latest code to the cluster. The Jenkins job executes setup.sh with the service name, build version of the service, ansible build version, the name script to be executed (deploy.sh by default) and number of instances to deploy to parallely as parameters. 

2. setup.sh executes an ansible playbook deploy.yml

3. deploy.yml executes deploy.sh. Deploy.sh is very similar to the AWS launch configuration user data


### nagios-config-generator
Since Nagios does not maintain dynamic inventory, this script when setup as a cron job polls for ASG changes every few minutes and updates the hosts in the Nagios monitoring config.
