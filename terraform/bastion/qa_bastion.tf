provider "aws" {
    region = "${var.aws_region}"
}

resource "aws_instance" "bastion_qa" {
  ami = "${lookup(var.ami_exotel_generic, var.aws_region)}"
  instance_type = "${var.instance_type}"
  key_name = "${lookup(var.ec2_key_pair, var.aws_region)}"
  vpc_security_group_ids = ["${aws_security_group.bastion_qa_sg.id}"]
  subnet_id = "${var.generic_public_subnet_a}"
  iam_instance_profile = "${aws_iam_instance_profile.bastion_qa_profile.name}"
  tags {
    Name = "bastion_qa"
    env = "${var.domain}"
  }
}


#Creating the security group for the public ELBs
resource "aws_security_group" "bastion_qa_sg" {
  name        = "bastion_qa_sg"
  description = "sg for bastion_qa instance"
  vpc_id      = "${var.vpc_id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 22000
    to_port     = 22000
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

resource "aws_iam_instance_profile" "bastion_qa_profile" {
    name = "bastion_qa_role"
    roles = ["${aws_iam_role.bastion_qa_role.name}"]
}

resource "aws_iam_role" "bastion_qa_role" {
    name = "bastion_qa_role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}



resource "aws_iam_role_policy" "bastion_qa_policy" {
  name = "bastion_qa_policy"
  role = "${aws_iam_role.bastion_qa_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:Get*",
        "s3:List*",
    "ec2:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "autoscaling:*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "opsworks:*",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeKeyPairs",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeAccountAttributes",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcs",
        "elasticloadbalancing:DescribeInstanceHealth",
        "elasticloadbalancing:DescribeLoadBalancers",
        "iam:GetRolePolicy",
        "iam:ListInstanceProfiles",
        "iam:ListRoles",
        "iam:ListUsers",
        "iam:PassRole"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "autoscaling:DescribeAutoScalingGroups",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "autoscaling:SetDesiredCapacity",
      "Resource": "*"
    }
  ]

}
EOF
}

