resource "aws_alb_target_group" "obelix-appengine-target-group"{
    name     = "obelix-appengine-target-group"
    port     = "${var.protocol_port}"
    protocol = "${var.protocol_type}"
    vpc_id   = "${var.vpc_id}"
    health_check {
    healthy_threshold = "${var.healthy-threshold-count}"
    interval = "${var.health-check-interval-seconds}"
    matcher =  "${var.matcher}"
    path =  "${var.health-check-path}"
    port =  "${var.health-check-port}"
    protocol = "${var.health-check-protocol}"
    timeout = "${var.health-check-timeout-seconds}"
    unhealthy_threshold = "${var.unhealthy-threshold-count}"
    }
    deregistration_delay = "${var.deregistration_delay}"
}

resource "aws_alb" "obelix-appengine-alb" {
    name            = "obelix-appengine-alb"
    internal        = false
    security_groups = ["${aws_security_group.obelix-appengine-alb_sg.id}"]
    subnets         = ["${aws_subnet.obelix-appengine-alb_public_a.id}","${aws_subnet.obelix-appengine-alb_public_b.id}"]
    enable_deletion_protection = false
    access_logs {
      bucket = "${aws_s3_bucket.elb-accesslogs-obelix-appengine-qa.bucket}"
    }
    tags {
      env = "qa"
    }
}

resource "aws_s3_bucket" "elb-accesslogs-obelix-appengine-qa" {
    bucket = "elb-accesslogs-obelix-appengine-qa"
    acl = "private"
    force_destroy = "true"
    tags {
        Name = "elb-accesslogs-obelix-appengine-qa"
        env = "qa"
    }
    policy = <<EOF
{
"Id": "Policy1485434794254",
"Version": "2012-10-17",
"Statement": [
  {
    "Sid": "Stmt1485434777691",
    "Action": [
      "s3:PutObject"
    ],
    "Effect": "Allow",
    "Resource": "arn:aws:s3:::elb-accesslogs-obelix-appengine-qa/AWSLogs/123456789/*",
    "Principal": {
      "AWS": [
        "1234568"
      ]
    }
  }
]
}
EOF
}



resource "aws_alb_listener" "obelix-appengine-alb_listner1" {
   load_balancer_arn = "${aws_alb.obelix-appengine-alb.arn}"
   port = "80"
   protocol = "HTTP"
   default_action {
     target_group_arn = "${aws_alb_target_group.obelix-appengine-target-group.arn}"
     type = "forward"
   }
}


resource "aws_alb_listener" "obelix-appengine-alb_listner2" {
   load_balancer_arn = "${aws_alb.obelix-appengine-alb.arn}"
   port = "443"
   protocol = "HTTPS"
   ssl_policy = "ELBSecurityPolicy-2015-05"
   certificate_arn = "${var.certificate_arn}"
   default_action {
     target_group_arn = "${aws_alb_target_group.obelix-appengine-target-group.arn}"
     type = "forward"
   }
}
