#Create the private hosted zone for the domain
resource "aws_route53_zone" "private" {
  name = "internal.apec1.qaexotel.in"
  vpc_id = "${aws_vpc.vpc_qa.id}"
  tags {
    Type = "private"
    Env = "${var.domain}"
  }
}
