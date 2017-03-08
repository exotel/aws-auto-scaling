/*
  Private Subnet
*/
resource "aws_subnet" "obelix_appengine_private_a" {
    vpc_id = "${var.vpc_id}"

    cidr_block = "${var.private_cidr_block_a}"
    availability_zone = "${var.availability_zones_a}"

    tags {
        Name = "obelix_Subnet_a"
    }
}

/*
  Private Subnet
*/
resource "aws_subnet" "obelix_appengine_private_b" {
    vpc_id = "${var.vpc_id}"

    cidr_block = "${var.private_cidr_block_b}"
    availability_zone = "${var.availability_zones_b}"

    tags {
        Name = "obelix_Subnet_b"
    }
}


resource "aws_route_table_association" "obelix_appengine_private_a_association" {
    subnet_id = "${aws_subnet.obelix_appengine_private_a.id}"
    route_table_id = "${var.private_route_table}"
}


resource "aws_route_table_association" "obelix_appengine_private_b_association" {
    subnet_id = "${aws_subnet.obelix_appengine_private_b.id}"
    route_table_id = "${var.private_route_table}"
}




/*
  public Subnet
*/
resource "aws_subnet" "obelix-appengine-alb_public_a" {
    vpc_id = "${var.vpc_id}"

    cidr_block = "${var.public_cidr_block_a}"
    availability_zone = "${var.availability_zones_a}"

    tags {
        Name = "obelix_alb_public_Subnet_a"
    }
}

/*
  public Subnet
*/
resource "aws_subnet" "obelix-appengine-alb_public_b" {
    vpc_id = "${var.vpc_id}"

    cidr_block = "${var.public_cidr_block_b}"
    availability_zone = "${var.availability_zones_b}"

    tags {
        Name = "obelix_alb_public_Subnet_b"
    }
}

resource "aws_route_table_association" "obelix-appengine-alb_public_b_association" {
    subnet_id = "${aws_subnet.obelix-appengine-alb_public_b.id}"
    route_table_id = "${var.public_route_table}"
}

resource "aws_route_table_association" "obelix-appengine-alb_public_a_association" {
    subnet_id = "${aws_subnet.obelix-appengine-alb_public_a.id}"
    route_table_id = "${var.public_route_table}"
}