#!/bin/bash
#
# The ideal time to run this script is to each 5 seconds. On panic, it should trigger a mail as well
#
# Source: https://aws.amazon.com/blogs/aws/new-ec2-spot-instance-termination-notices/
# 
# Where this script will run, the instance must be assigned role with following
# policy-
#   SpotInstancePolicy
# 	{
# 	    "Version": "2012-10-17",
# 	    "Statement": [
# 	        {
# 	            "Effect": "Allow",
# 	            "Action": "autoscaling:DescribeAutoScalingGroups",
# 	            "Resource": "*"
# 	        },
# 	        {
# 	            "Effect": "Allow",
# 	            "Action": "autoscaling:SetDesiredCapacity",
# 	            "Resource": "*"
# 	        }
# 	    ]
# 	}
# pre check:
# to run this script you must pass the name of desired scaling group name.

if [ $# -ne 2 ]; then
	echo ""`date`" : You have not passed all parameter. Usage: spot_termination_notifier.sh <desired_scaling_group_name> [region]"
	exit 1
fi

# default region
region="ap-southeast-1"
if [ $# -eq 2 ]; then
	region=$2
fi

# eg. obelix-public-spot-asg

target_group=$1
script_name=/home/ec2-user/termination_scripts/$target_group.sh
target_ondemand_group=$(echo $target_group | sed -r 's/spot/ondemand/g')

# start process
TO_MAIL='XXX@YYY.com'
CHECK_FILE='/tmp/spot-instance-termination-notices'

# checking status, it'll return non-404 if the termination time is set
http_status=`curl -Is 'http://169.254.169.254/latest/meta-data/spot/termination-time' | grep HTTP | cut -d' ' -f2`
echo "HTTP code for endpoint http://169.254.169.254/latest/meta-data/spot/termination-time = $http_status"


if [ $http_status -eq 404 ]; then
	# it's ok
	if [ -e $CHECK_FILE ]; then
		# this is not possible, it will never come here!
		rm $CHECK_FILE
	fi
elif [ $http_status -eq 200 ]; then
	# panic
	if [ ! -e $CHECK_FILE ]; then
		curl -s 'http://169.254.169.254/latest/meta-data/spot/termination-time' > $CHECK_FILE
		# 
		# perform one time operation here
		if [ ! -e $script_name]; then
			scriptError="I have not any extra script as $script_name was not present there."
		else
			bash $script_name > script_log_file
			scriptError="I have also executed $script_name."
			script_log= $(cat script_log_file)
		fi

		group_info=`aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name $target_ondemand_group --region $region`
		old_cap=`echo $group_info | awk -F=":" -v RS="," '$1~/"DesiredCapacity"/ {print}' | cut -d' ' -f3`
		max_capacity=`echo $group_info | awk -F=":" -v RS="," '$1~/"MaxSize"/ {print}' | cut -d' ' -f3`
                min_capacity=`echo $group_info | awk -F=":" -v RS="," '$1~/"MinSize"/ {print}' | cut -d' ' -f3`
		if [max_capacity -le  old_cap] ; then
			aws autoscaling set-max-size --auto-scaling-group-name $target_ondemand_group --max-size $(( old_cap + 1 )) --region $region
		fi
		# increasing desired-capacity by 1
		aws autoscaling set-desired-capacity --auto-scaling-group-name $target_ondemand_group --desired-capacity $(( old_cap + 1 )) --region $region --no-honor-cooldown
		if [min_capacity -le  old_cap] ; then
                        aws autoscaling set-min-size --auto-scaling-group-name $target_ondemand_group --min-size $(( old_cap + 1 )) --region $region
                fi

                group_info=`aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name $target_ondemand_group --region $region`
                current_cap=`echo $group_info | awk -F=":" -v RS="," '$1~/"DesiredCapacity"/ {print}' | cut -d' ' -f3`
                max_capacity=`echo $group_info | awk -F=":" -v RS="," '$1~/"MaxSize"/ {print}' | cut -d' ' -f3`
                min_capacity=`echo $group_info | awk -F=":" -v RS="," '$1~/"MinSize"/ {print}' | cut -d' ' -f3`
                terminate_time=`cat $CHECK_FILE`
                echo "Current details for $target_ondemand_group"
                echo "old_cap = $old_cap"
                echo "current_cap = $current_cap"
                echo "max_size = $max_capacity"
                echo "min_size = $min_capacity"
		instance_id=`curl -s 'http://169.254.169.254/latest/meta-data/instance-id'`
		echo "Hey Team,
        
		This is an automated email to tell you that instance $instance_id from $target_group will be terminated 
		at $terminate_time because spot price has been increased than what you have mentioned. I have increased
		$target_ondemand_group size by one.

		$scriptError  Here I am also attaching logs for your scripts.
		$script_log
                HTTP code for endpoint http://169.254.169.254/latest/meta-data/spot/termination-time = $http_status
                Current details for $target_ondemand_group
                old_cap = $old_cap
                current_cap = $current_cap
                max_size = $max_capacity
                min_size = $min_capacity
                
		Please check this ASAP.
		----
		Yours,
		Instance $instance_id" | mail -s "Spot instance notification - $instance_id" "$TO_MAIL"
	fi
	# Do something here, if you want to keep working when this instance is going to die
fi
