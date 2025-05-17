provider "aws" {
  region = "us-east-1"
}

module "ec2" {
  source = "./modules/ec2"
  ami = var.ami
  ec2_instance_type = var.ec2_instance_type

}

module "vpc" {
  source               = "./modules/vpc"
  name                 = "my-vpc"
  region               = "us-east-1"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
  tags = {
    Environment = "dev"
    Project     = "ModularVPC"
  }
}

