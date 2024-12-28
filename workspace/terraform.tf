terraform {
  backend "s3" {
    bucket = "my-demo-terraform-s3-bucket"
    key = "terraform.tfstate"
    region = "us-east-1"
  }
}
