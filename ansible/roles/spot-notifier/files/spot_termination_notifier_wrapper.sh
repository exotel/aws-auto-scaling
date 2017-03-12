#!/bin/bash
if [ $# -ne 2 ]; then
	echo "ERROR: Please provide scriptname and asg name."
else

	CMD="$1 $2 ap-southeast-1"  
        echo $CMD
	(sleep 5 && /bin/bash /home/ec2-user/termination_scripts/$CMD ) &
	(sleep 10 && /bin/bash /home/ec2-user/termination_scripts/$CMD ) &
	(sleep 15 && /bin/bash /home/ec2-user/termination_scripts/$CMD ) &
	(sleep 20 && /bin/bash /home/ec2-user/termination_scripts/$CMD ) &
	(sleep 25 && /bin/bash /home/ec2-user/termination_scripts/$CMD ) &
	(sleep 30 && /bin/bash /home/ec2-user/termination_scripts/$CMD ) &
	(sleep 35 && /bin/bash /home/ec2-user/termination_scripts/$CMD ) &
	(sleep 40 && /bin/bash /home/ec2-user/termination_scripts/$CMD ) &
	(sleep 45 && /bin/bash /home/ec2-user/termination_scripts/$CMD ) &
	(sleep 50 && /bin/bash /home/ec2-user/termination_scripts/$CMD ) &
	(sleep 55 && /bin/bash /home/ec2-user/termination_scripts/$CMD ) &
	(sleep 60 && /bin/bash /home/ec2-user/termination_scripts/$CMD ) &
fi

