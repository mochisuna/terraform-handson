resource "aws_vpc" "vpc" {
  cidr_block = "${var.root_block}"

  tags {
    Name = "${var.vpc_name}"
    Env  = "${terraform.env}"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.vpc_name} default-security-group"
    Env  = "${terraform.env}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.vpc_name} internet-gateway"
    Env  = "${terraform.env}"
  }
}

resource "aws_eip" "eip-a" {
  vpc = true

  tags {
    Name = "${var.vpc_name} eip-a"
    Env  = "${terraform.env}"
  }
}

resource "aws_eip" "eip-c" {
  vpc = true

  tags {
    Name = "${var.vpc_name} eip-c"
    Env  = "${terraform.env}"
  }
}

resource "aws_nat_gateway" "nat-gw-a" {
  allocation_id = "${aws_eip.eip-a.id}"
  subnet_id     = "${aws_subnet.public-subnet-a.id}"

  depends_on = ["aws_internet_gateway.igw"]

  tags {
    Name = "${var.vpc_name} nat-gateway-a"
    Env  = "${terraform.env}"
  }
}

resource "aws_nat_gateway" "nat-gw-c" {
  allocation_id = "${aws_eip.eip-c.id}"
  subnet_id     = "${aws_subnet.public-subnet-c.id}"

  depends_on = ["aws_internet_gateway.igw"]

  tags {
    Name = "${var.vpc_name} nat-gateway-c"
    Env  = "${terraform.env}"
  }
}

resource "aws_subnet" "public-subnet-a" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.public_block_a}"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.vpc_name} public-subnet-a"
    Env  = "${terraform.env}"
  }
}

resource "aws_subnet" "public-subnet-c" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.public_block_c}"
  availability_zone       = "${var.region}c"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.vpc_name} public-subnet-c"
    Env  = "${terraform.env}"
  }
}

resource "aws_subnet" "private-subnet-a" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.private_block_a}"
  availability_zone = "${var.region}a"

  tags {
    Name = "${var.vpc_name} private-subnet-a"
    Env  = "${terraform.env}"
  }
}

resource "aws_subnet" "private-subnet-c" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.private_block_c}"
  availability_zone = "${var.region}c"

  tags {
    Name = "${var.vpc_name} private-subnet-c"
    Env  = "${terraform.env}"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "${var.vpc_name} public route-table"
    Env  = "${terraform.env}"
  }
}

resource "aws_route_table" "private-rt-a" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat-gw-a.id}"
  }

  tags {
    Name = "${var.vpc_name} private route-table-a"
    Env  = "${terraform.env}"
  }
}

resource "aws_route_table" "private-rt-c" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat-gw-c.id}"
  }

  tags {
    Name = "${var.vpc_name} private route-table-c"
    Env  = "${terraform.env}"
  }
}

resource "aws_route_table_association" "public-rta-a" {
  subnet_id      = "${aws_subnet.public-subnet-a.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}

resource "aws_route_table_association" "public-rta-c" {
  subnet_id      = "${aws_subnet.public-subnet-c.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}

resource "aws_route_table_association" "private-rta-a" {
  subnet_id      = "${aws_subnet.private-subnet-a.id}"
  route_table_id = "${aws_route_table.private-rt-a.id}"
}

resource "aws_route_table_association" "private-rta-c" {
  subnet_id      = "${aws_subnet.private-subnet-c.id}"
  route_table_id = "${aws_route_table.private-rt-c.id}"
}
