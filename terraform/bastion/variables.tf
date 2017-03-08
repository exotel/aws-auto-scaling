variable "availability_zones" {
	type    = "list"
	default = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "availability_zones_a" {
  type = "string"
  default = "ap-southeast-1a"
}

variable "availability_zones_b" {
  type = "string"
  default = "ap-southeast-1b"
}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "ap-southeast-1"
}

variable "instance_type" {
    type = "string"
    default = "t2.micro"
}

variable "ec2_key_pair" {
  default = {
    ap-southeast-1 = "exotel-qa"
  }
}

variable "generic_public_subnet_a" {
  default = "subnet-4f83fa2b"
}

variable "ami_exotel_generic" {
    description = "AMIs by region"
    default = {
        ap-southeast-1 = "ami-7a6bc919"
    }
}

variable "vpc_id" {
    description = "VPC"
    default = "vpc-0cfa4468"
}

variable "domain" {
  default = "qa"
}
