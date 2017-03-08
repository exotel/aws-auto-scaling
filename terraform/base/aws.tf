provider "aws" {
    region = "${var.aws_region}"
}

resource "aws_vpc" "vpc_qa" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "${var.vpc_name}"
        Method = "Terraform"
    }
}

resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = "${aws_vpc.vpc_qa.id}"
     tags {
        Name = "${var.internet_gateway_name}"
        Method = "Terraform"
    }
}

resource "aws_route" "internet_access" {
  ### using default routetable. This is present when we create vpc
  route_table_id         = "${aws_vpc.vpc_qa.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.internet_gateway.id}"
}

resource "aws_eip" "natgateway_eip" {
  vpc      = true
  depends_on = ["aws_internet_gateway.internet_gateway"]
  ######depend_on: Conditional variable which say in this case the EIP resource should be created after the Internet Gateway is already created
}

resource "aws_nat_gateway" "nat_gateway" {
    allocation_id = "${aws_eip.natgateway_eip.id}"
    subnet_id = "${aws_subnet.public_generic_a.id}"
    depends_on = ["aws_internet_gateway.internet_gateway"]
}

resource "aws_route_table" "private_route_table" {
    vpc_id = "${aws_vpc.vpc_qa.id}"
 
    tags {
        Name = "Private_route_table"
    }
}
 
resource "aws_route" "private_route" {
	route_table_id  = "${aws_route_table.private_route_table.id}"
	destination_cidr_block = "0.0.0.0/0"
	nat_gateway_id = "${aws_nat_gateway.nat_gateway.id}"
}

/*
  Public Subnet
*/

resource "aws_subnet" "public_generic_b" {
    vpc_id = "${aws_vpc.vpc_qa.id}"

    cidr_block = "${var.public_subnet_cidr_b}"
    availability_zone = "${var.availability_zones_b}"
    map_public_ip_on_launch = true
    tags {
        Name = "Public_Subnet_b"
    }
}

/*
  Private Subnet
*/
resource "aws_subnet" "private_generic_a" {
    vpc_id = "${aws_vpc.vpc_qa.id}"

    cidr_block = "${var.private_subnet_cidr_a}"
    availability_zone = "${var.availability_zones_a}"

    tags {
        Name = "Private_Subnet_a"
    }
}


/*
  Public Subnet
*/

resource "aws_subnet" "public_generic_a" {
    vpc_id = "${aws_vpc.vpc_qa.id}"

    cidr_block = "${var.public_subnet_cidr_a}"
    availability_zone = "${var.availability_zones_a}"
    map_public_ip_on_launch = true
    tags {
        Name = "Public_Subnet_a"
    }
}

/*
  Private Subnet
*/
resource "aws_subnet" "private_generic_b" {
    vpc_id = "${aws_vpc.vpc_qa.id}"

    cidr_block = "${var.private_subnet_cidr_b}"
    availability_zone = "${var.availability_zones_b}"

    tags {
        Name = "Private_Subnet_b"
    }
}

resource "aws_route_table_association" "public_generic_b_association" {
    subnet_id = "${aws_subnet.public_generic_b.id}"
    route_table_id = "${aws_vpc.vpc_qa.main_route_table_id}"
}
 
# Associate subnet private_1_subnet_eu_west_1a to private route table
resource "aws_route_table_association" "private_generic_b_association" {
    subnet_id = "${aws_subnet.private_generic_b.id}"
    route_table_id = "${aws_route_table.private_route_table.id}"
}


resource "aws_route_table_association" "public_generic_a_association" {
    subnet_id = "${aws_subnet.public_generic_a.id}"
    route_table_id = "${aws_vpc.vpc_qa.main_route_table_id}"
}
 
# Associate subnet private_1_subnet_eu_west_1a to private route table
resource "aws_route_table_association" "private_generic_a_association" {
    subnet_id = "${aws_subnet.private_generic_a.id}"
    route_table_id = "${aws_route_table.private_route_table.id}"
}


#Creating the security group for the public ELBs
resource "aws_security_group" "generic_sg" {
  name        = "generic_sg"
  description = "sg for generic instance"
  vpc_id = "${aws_vpc.vpc_qa.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22000
    to_port     = 22000
    protocol    = "TCP"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # port for generic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # port for generic
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # port for generic
  ingress {
    from_port   = 443
    to_port     = 443
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
