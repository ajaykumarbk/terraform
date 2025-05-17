provider "aws" {
  region = "us-east-1"
}

module "ec2" {
  source = "./modules/ec2"
  ami = var.ami
  ec2_instance_type = var.ec2_instance_type

}
