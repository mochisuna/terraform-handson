provider "aws" {
  version    = "~> 1.0"
  region     = "sa-east-1"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

variable "aws_access_key" {}
variable "aws_secret_key" {}

resource "aws_instance" "web" {
  ami           = "ami-84175ae8"
  instance_type = "t2.micro"
  monitoring    = true

  tags {
    Name = "name" // fix your name
  }
}
