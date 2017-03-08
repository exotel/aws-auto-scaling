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

variable "amis" {
    description = "AMIs by region"
    default = {
        ap-southeast-1 = "ami-XXXX"
    }
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr_a" {
    description = "CIDR for the Public Subnet"
    default = "10.0.0.0/24"
}

variable "private_subnet_cidr_a" {
    description = "CIDR for the Private Subnet"
    default = "10.0.2.0/24"
}

variable "public_subnet_cidr_b" {
    description = "CIDR for the Public Subnet"
    default = "10.0.1.0/24"
}

variable "private_subnet_cidr_b" {
    description = "CIDR for the Private Subnet"
    default = "10.0.3.0/24"
}

variable "vpc_name" {
	default="vpc-southeast1-qa"
}

variable "internet_gateway_name" {
	default="internet_gateway_southeast1_qa"
}

variable "domain" {
    default="qa"
}