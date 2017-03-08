provider "aws" {
  region = "ap-southeast-1"
}

variable "availability_zones" {
	default = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "maximum_size_for_ondemand" {
	default=100
}

variable "minimum_size_for_ondemand" {
	default=1
}

variable "maximum_size_for_spot" {
	default=100
}

variable "minimum_size_for_spot" {
	default=1
}

variable "health_check_period" {
	default=60
}

variable "cooldown_period" {
	default=300
}

variable "desired_capacity"{
	default=1
}

variable "vpc_id" {
  default = "vpc-xxxxx"
}

variable "private_cidr_block_a" {
	default = "10.0.4.0/25"
}

variable "private_cidr_block_b" {
	default = "10.0.4.128/25"
}

variable "public_cidr_block_a" {
	default = "10.0.5.16/28"
}

variable "public_cidr_block_b" {
	default = "10.0.5.0/28"
}

variable "asg_base_ami" {
  default = "ami-xxxxx"
}

variable "instance_type_spot" {
  default = "m4.large"
}

variable "instance_type_ondemand" {
  default = "m4.large"
}

variable "spot_price" {
	default = "2.00"
}

variable "ec2_key_pair" {
  default = "exotel-qa"
}

variable "availability_zones_a" {
  type = "string"
  default = "ap-southeast-1a"
}

variable "availability_zones_b" {
  type = "string"
  default = "ap-southeast-1b"
}

variable "private_route_table" {
	default="rtb-xxxx"
}

variable "public_route_table" {
	default="rtb-xxxx"
}

variable "domain" {
  type = "string"
  default = "prod"
}

variable "env" {
  type = "string"
  default = "qa"
}

variable "instance_profile" {
  default = "qa_ec2_role"
}


############################################
############################################
######### target group variables ###########
############################################
############################################


variable "protocol_port"{
	default=80
}

variable "protocol_type"{
	default = "HTTP"
}

variable "health-check-protocol" {
    default = "HTTP"
 } 

variable "health-check-port" {
	default= 80 
}
variable  "health-check-path" {
	default = "/elb-healthcheck/index.php"
} 
variable  "health-check-interval-seconds" {
	default = 6	
}  
variable "health-check-timeout-seconds" {
	default = 5
}

variable  "healthy-threshold-count" {
	default= 2
} 
variable  "unhealthy-threshold-count" {
	default= 4
}
variable  "matcher" {
	default= "200"
} 

variable "email" {
	default = "xyz@foobar.com"
}


variable "deregistration_delay" {
	default = "300"
}

variable "alb_4xx_thershold" {
	default = 50
}

variable "alb_5xx_thershold" {
	default = 50
}

variable "alb_latency_thershold" {
	default = 600
}

variable "alb_target_5xx_thershold" {
	default = 50
}

variable "cpu_upper_thershold" {
	default = 85
}

variable "cpu_lower_thershold" {
	default = 55
}

variable "cpu_spot_upper_thershold" {
	default = 50
}

variable "cpu_spot_lower_thershold" {
	default = 30
}

variable "certificate_arn" {
	default = "arn:aws:acm:ap-southeast-1:123456789:certificate/XXXXX-c7ed-4f5d-911c-ead02"
}
