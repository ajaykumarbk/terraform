provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "AWS-BACKEND-VM" {
  instance_type = "t2.micro"
  ami = "ami-0e2c8caa4b6378d8c"
  subnet_id = "subnet-0f4a06a9b6e47d752"
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "ajay-s3-demo-xyz"
}
