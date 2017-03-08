resource "aws_autoscaling_group" "obelix_appengine_spot_asg" {
  availability_zones = "${var.availability_zones}"
  name = "obelix_appengine_spot_asg"
  max_size = "${var.maximum_size_for_spot}"
  min_size = "${var.minimum_size_for_spot}"
  health_check_grace_period = "${var.health_check_period}"
  health_check_type = "EC2"
  default_cooldown = "${var.cooldown_period}"
  desired_capacity = "${var.desired_capacity}"
  launch_configuration = "${aws_launch_configuration.obelix_appengine_spot_lc.name}"
  vpc_zone_identifier = ["${aws_subnet.obelix_appengine_private_a.id}", "${aws_subnet.obelix_appengine_private_b.id}"]
  target_group_arns = ["${aws_alb_target_group.obelix-appengine-target-group.arn}"]
  tag {
    key = "service"
    value = "obelix-appengine"
    propagate_at_launch = true
  }
  tag {
    key = "lifecycle"
    value = "spot"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "obelix_appengine_spot_lc" {
    name = "obelix_appengine_spot_lc"
    image_id = "${var.asg_base_ami}"
    instance_type = "${var.instance_type_spot}"
    iam_instance_profile = "${var.instance_profile}"
    spot_price = "${var.spot_price}"
    key_name = "${var.ec2_key_pair}"
    security_groups = ["${aws_security_group.obelix_appengine_asg_sg.id}"]
    user_data = "${file("userdata/obelix_appengine")}"
    enable_monitoring = false
    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_autoscaling_policy" "obelix-appengine-spot-5min-scale-out-policy" {
    adjustment_type = "PercentChangeInCapacity"
    autoscaling_group_name = "${aws_autoscaling_group.obelix_appengine_spot_asg.name}"
    estimated_instance_warmup = 180
    metric_aggregation_type = "Average"
    name = "obelix-appengine-spot-5min-scale-out-policy"
    policy_type = "StepScaling"
    min_adjustment_magnitude = 1
    step_adjustment {
       metric_interval_lower_bound = "0"
       scaling_adjustment =  "10"
       metric_interval_upper_bound = "15"
    }   
    step_adjustment {
       metric_interval_lower_bound = "15"
       scaling_adjustment =  "40"
    }  
}


resource "aws_autoscaling_policy" "obelix-appengine-spot-2min-scale-out-policy" {
    adjustment_type = "PercentChangeInCapacity"
    autoscaling_group_name = "${aws_autoscaling_group.obelix_appengine_spot_asg.name}"
    estimated_instance_warmup = 180
    metric_aggregation_type = "Average"
    name = "obelix-appengine-spot-2min-scale-out-policy"
    policy_type = "StepScaling"
    step_adjustment {
       metric_interval_lower_bound = "0"
       scaling_adjustment =  "100"
    }    
}

resource "aws_autoscaling_policy" "obelix-appengine-spot-scale-in-policy" {
    adjustment_type = "PercentChangeInCapacity"
    autoscaling_group_name = "${aws_autoscaling_group.obelix_appengine_spot_asg.name}"
    cooldown = 300
    name = "obelix-appengine-spot-scale-in-policy"
    policy_type = "SimpleScaling"
    min_adjustment_magnitude = 1
    scaling_adjustment =  "-10" 
}
