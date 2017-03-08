resource "aws_cloudwatch_metric_alarm" "obelix-appengine-alb_4xx" {
    alarm_description = "Alarm for obelix-appengine-alb 4xx > 2500 for 1m"
    alarm_name =  "obelix-appengine-alb_4xx"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    actions_enabled = "true"
    metric_name = "HTTPCode_Target_4XX_Count"
    evaluation_periods = "1"
    period = "60"
    namespace = "AWS/ApplicationELB"
    statistic = "Sum"
    threshold = "${var.alb_4xx_thershold}"
    alarm_actions =  ["${aws_sns_topic.devops_emails_obelix_appengine.arn}"]
    dimensions {
        LoadBalancerName = "${aws_alb.obelix-appengine-alb.name}"
    }
}



resource "aws_cloudwatch_metric_alarm" "obelix-appengine-alb_elb_5xx" {
    alarm_description = "Alarm for obelix-appengine-alb elb 5xx > 50 for 1m"
    alarm_name = "obelix-appengine-alb_elb_5xx"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    actions_enabled = "true"
    metric_name = "HTTPCode_ELB_5XX_Count"
    evaluation_periods = "1"
    period = "60"
    namespace = "AWS/ApplicationELB"
    statistic = "Maximum"
    threshold = "${var.alb_5xx_thershold}"
    alarm_actions =  ["${aws_sns_topic.devops_emails_obelix_appengine.arn}"]
    dimensions {
        LoadBalancerName = "${aws_alb.obelix-appengine-alb.name}"
    }
}

   
resource "aws_cloudwatch_metric_alarm" "obelix-appengine-alb_latency" {
    alarm_description = "Alarm for obelix-appengine-alb latency > 600ms for 1m"
    alarm_name = "obelix-appengine-alb_latency"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    actions_enabled = "true"
    metric_name = "TargetResponseTime"
    evaluation_periods = "1"
    period = "60"
    namespace = "AWS/ApplicationELB"
    statistic = "Maximum"
    threshold = "${var.alb_latency_thershold}"
    alarm_actions =  ["${aws_sns_topic.devops_emails_obelix_appengine.arn}"]
    dimensions {
        LoadBalancerName = "${aws_alb.obelix-appengine-alb.name}"
    }   
}


resource "aws_cloudwatch_metric_alarm" "obelix-appengine-alb_target_5xx" {
    alarm_description = "Alarm for obelix-appengine-alb_target 5xx > 50 for 1m"
    alarm_name = "obelix-appengine-alb_target_5xx"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    actions_enabled = "true"
    metric_name = "HTTPCode_Target_5XX_Count"
    evaluation_periods = "1"
    period = "60"
    namespace = "AWS/ApplicationELB"
    statistic = "Maximum"
    threshold = "${var.alb_target_5xx_thershold}"
    alarm_actions =  ["${aws_sns_topic.devops_emails_obelix_appengine.arn}"]
    dimensions {
        LoadBalancerName = "${aws_alb.obelix-appengine-alb.name}"
    }   
}


resource "aws_cloudwatch_metric_alarm" "obelix_appengine_ondemand_high_cpu_alarm" {
    alarm_description = "obelix_appengine_ondemand_high_cpu_alarm"
    alarm_name =  "obelix_appengine_ondemand_high_cpu_alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    actions_enabled = "true"
    metric_name = "CPUUtilization"
    evaluation_periods = "1"
    period = "300"
    namespace = "AWS/EC2"
    statistic = "Average"
    threshold = "${var.cpu_upper_thershold}"
    alarm_actions =  ["${aws_autoscaling_policy.obelix_appengine_ondemand_scale_out_policy.arn}"]
    dimensions {
        AutoScalingGroupName = "${aws_autoscaling_group.obelix_appengine_ondemand_asg.name}"
    } 
}

resource "aws_cloudwatch_metric_alarm" "obelix_appengine_ondemand_low_cpu_alarm" {
    alarm_description = "obelix_appengine_ondemand_low_cpu_alarm"
    alarm_name =  "obelix_appengine_ondemand_low_cpu_alarm"
    comparison_operator = "LessThanThreshold"
    actions_enabled = "true"
    metric_name = "CPUUtilization"
    evaluation_periods = "10"
    period = "300"
    namespace = "AWS/EC2"
    statistic = "Average"
    threshold = "${var.cpu_lower_thershold}"
    alarm_actions =  ["${aws_autoscaling_policy.obelix_appengine_ondemand_scale_in_policy.arn}"]
    dimensions {
        AutoScalingGroupName = "${aws_autoscaling_group.obelix_appengine_ondemand_asg.name}"
    }     
}


resource "aws_cloudwatch_metric_alarm" "obelix-appengine-spot-5min-high-cpu-alarm" {
    alarm_description = "obelix-appengine-spot-5min-high-cpu-alarm"
    alarm_name =  "obelix-appengine-spot-5min-high-cpu-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    actions_enabled = "true"
    metric_name = "CPUUtilization"
    evaluation_periods = "1"
    period = "300"
    namespace = "AWS/EC2"
    statistic = "Average"
    threshold = "${var.cpu_spot_upper_thershold}"
    alarm_actions =  ["${aws_autoscaling_policy.obelix-appengine-spot-5min-scale-out-policy.arn}"]
    dimensions {
        AutoScalingGroupName = "${aws_autoscaling_group.obelix_appengine_spot_asg.name}"
    } 
}



resource "aws_cloudwatch_metric_alarm" "obelix-appengine-spot-2min-high-cpu-alarm" {
    alarm_description = "obelix-appengine-spot-2min-high-cpu-alarm"
    alarm_name =  "obelix-appengine-spot-2min-high-cpu-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    actions_enabled = "true"
    metric_name = "CPUUtilization"
    evaluation_periods = "2"
    period = "60"
    namespace = "AWS/EC2"
    statistic = "Average"
    threshold = "${var.cpu_upper_thershold}"
    alarm_actions =  ["${aws_autoscaling_policy.obelix-appengine-spot-2min-scale-out-policy.arn}"]
    dimensions {
        AutoScalingGroupName = "${aws_autoscaling_group.obelix_appengine_spot_asg.name}"
    } 
}


resource "aws_cloudwatch_metric_alarm" "obelix-appengine-spot-low-cpu-alarm" {
    alarm_description = "obelix-appengine-spot-low-cpu-alarm"
    alarm_name =  "obelix-appengine-spot-low-cpu-alarm"
    comparison_operator = "LessThanThreshold"
    actions_enabled = "true"
    metric_name = "CPUUtilization"
    evaluation_periods = "10"
    period = "60"
    namespace = "AWS/EC2"
    statistic = "Average"
    threshold = "${var.cpu_spot_lower_thershold}"
    alarm_actions =  ["${aws_autoscaling_policy.obelix-appengine-spot-scale-in-policy.arn}"]
    dimensions {
        AutoScalingGroupName = "${aws_autoscaling_group.obelix_appengine_spot_asg.name}"
    } 
}
