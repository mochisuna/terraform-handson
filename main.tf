provider "aws" {
  version    = "~> 1.0"
  region     = "sa-east-1"
  access_key = ""          // 1. Fix
  secret_key = ""          // 1. Fix
}

resource "aws_instance" "web" {
  ami           = "ami-84175ae8"
  instance_type = "t2.micro"
  monitoring    = true

  tags {
    Name = "name" //2 fix your name
  }
}
