output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "default_security_group_id" {
  value = "${aws_default_security_group.default.id}"
}

output "public_subnet_a_id" {
  value = "${aws_subnet.public-subnet-a.id}"
}

output "public_subnet_c_id" {
  value = "${aws_subnet.public-subnet-c.id}"
}

output "private_subnet_a_id" {
  value = "${aws_subnet.private-subnet-a.id}"
}

output "private_subnet_c_id" {
  value = "${aws_subnet.private-subnet-c.id}"
}
