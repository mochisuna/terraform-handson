provider "aws" {
  version    = "~> 1.0"
  region     = "sa-east-1"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

variable "aws_access_key" {}
variable "aws_secret_key" {}

resource "aws_instance" "web" {
  ami                    = "ami-84175ae8"
  instance_type          = "t2.micro"
  monitoring             = true
  vpc_security_group_ids = ["${aws_security_group.allowed.id}"]
  key_name               = "${aws_key_pair.auth.id}"

  tags {
    Name = "name" // fix your name
  }
}

resource "aws_eip" "ec2-eip" {
  vpc      = true
  instance = "${aws_instance.web.id}"

  tags {
    Name = "handson-eip"
    Env  = "handson"
  }
}

resource "aws_security_group" "allowed" {
  name        = "tf-handson-sg"
  description = "Allow all inbound traffic from localhost"

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"

    cidr_blocks = [
      "127.0.0.1/32",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "handson-sg"
    Env  = "handson"
  }
}

resource "aws_key_pair" "auth" {
  key_name   = "tf-handson"
  public_key = "${file("~/.ssh/tf-handson.pub")}"
}
