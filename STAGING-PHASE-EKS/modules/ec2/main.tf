terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_instance" "node_group_1" {
  ami = var.ami
  instance_type = var.ec2_instance_type

  tags = {
    Name = "node_group_1"
  }
}