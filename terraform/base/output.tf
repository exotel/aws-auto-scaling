output "vpc_id" {
    value = "${aws_vpc.vpc_qa.id}"
}

output "internet_gateway" {
    value = "${aws_internet_gateway.internet_gateway.id}"
}

output "private_route_table" {
    value = "${aws_route_table.private_route_table.id}"
}

output "public_route_table" {
    value = "${aws_vpc.vpc_qa.main_route_table_id}"
}


output "private_generic_a" {
    value = "${aws_subnet.private_generic_a.id}"
}


output "natgateway_ip" {
    value = "${aws_eip.natgateway_eip.id}"
}

output "private_generic_b" {
    value = "${aws_subnet.private_generic_b.id}"
}

output "public_generic_b" {
    value = "${aws_subnet.public_generic_b.id}"
}

output "public_generic_a" {
    value = "${aws_subnet.public_generic_a.id}"
}

output "security_group_generic" {
    value = "${aws_security_group.generic_sg.id}"
}


output "qa_ec2_profile" {
    value = "${aws_iam_instance_profile.qa_ec2_profile.id}"
}

output "route53_zone" {
    value = "${aws_route53_zone.private.id}"
}
