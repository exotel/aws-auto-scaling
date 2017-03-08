resource "aws_autoscaling_group" "obelix_appengine_ondemand_asg" {
  availability_zones = "${var.availability_zones}"
  name = "obelix_appengine_ondemand_asg"
  max_size = "${var.maximum_size_for_ondemand}"
  min_size = "${var.minimum_size_for_ondemand}"
  health_check_grace_period = "${var.health_check_period}"
  health_check_type = "EC2"
  default_cooldown = "${var.cooldown_period}"
  desired_capacity = "${var.desired_capacity}"
  launch_configuration = "${aws_launch_configuration.obelix_appengine_ondemand_lc.name}"
  vpc_zone_identifier = ["${aws_subnet.obelix_appengine_private_a.id}", "${aws_subnet.obelix_appengine_private_b.id}"]
  target_group_arns = ["${aws_alb_target_group.obelix-appengine-target-group.arn}"]
  tag {
    key = "service"
    value = "obelix-appengine"
    propagate_at_launch = true
  }
  tag {
    key = "lifecycle"
    value = "ondemand"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "obelix_appengine_ondemand_lc" {
    name = "obelix_appengine_ondemand_lc"
    image_id = "${var.asg_base_ami}"
    instance_type = "${var.instance_type_ondemand}"
    iam_instance_profile = "${var.instance_profile}"
    key_name = "${var.ec2_key_pair}"
    security_groups = ["${aws_security_group.obelix_appengine_asg_sg.id}"]
    user_data = "${file("userdata/obelix_appengine")}"
    enable_monitoring = false
    lifecycle {
      create_before_destroy = true
    }
}


resource "aws_autoscaling_policy" "obelix_appengine_ondemand_scale_in_policy" {
    adjustment_type = "PercentChangeInCapacity"
    autoscaling_group_name = "${aws_autoscaling_group.obelix_appengine_ondemand_asg.name}"
    cooldown = "300"
    name = "obelix_appengine_ondemand_scale_in_policy"
    policy_type = "SimpleScaling"
    min_adjustment_magnitude = 1
    scaling_adjustment =  "-10" 
}

resource "aws_autoscaling_policy" "obelix_appengine_ondemand_scale_out_policy" {
    adjustment_type = "PercentChangeInCapacity"
    autoscaling_group_name = "${aws_autoscaling_group.obelix_appengine_ondemand_asg.name}"
    estimated_instance_warmup = 180
    metric_aggregation_type = "Average"
    name = "obelix_appengine_ondemand_scale_out_policy"
    policy_type = "StepScaling"
    min_adjustment_magnitude = 3
    step_adjustment {
       metric_interval_lower_bound = "0"
       scaling_adjustment =  "100"
    }   
}



