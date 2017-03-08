resource "aws_security_group" "obelix_appengine_asg_sg" {
  name        = "obelix_appengine_asg_sg"
  description = "sg for obelix_appengine_asg instance"
  vpc_id      = "${var.vpc_id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22000
    to_port     = 22000
    protocol    = "TCP"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # port for obelix_appengine_asg
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # ICMP access from anywhere
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "obelix-appengine-alb_sg" {
  name = "obelix-appengine-alb_sg"
  description = "sg for obelix-appengine-alb"
  vpc_id      = "${var.vpc_id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22000
    to_port     = 22000
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # port for obelix-appengine-alb
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ICMP access from anywhere
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
