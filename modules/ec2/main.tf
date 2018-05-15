resource "aws_instance" "web" {
  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  monitoring             = true
  vpc_security_group_ids = ["${aws_security_group.allowed.id}"]
  key_name               = "${aws_key_pair.auth.id}"

  tags {
    Name = "sample"
  }
}

resource "aws_eip" "ec2_eip" {
  vpc      = true
  instance = "${aws_instance.web.id}"

  tags {
    Name = "sample-eip"
    Env  = "sample"
  }
}

resource "aws_security_group" "allowed" {
  name        = "${var.sg_name}"
  description = "Allow all inbound traffic from localhost"

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "sample-sg"
    Env  = "sample"
  }
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_pair_name}"
  public_key = "${file("~/.ssh/${var.key_pair_name}.pub")}"
}
