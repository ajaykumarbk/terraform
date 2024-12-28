provider "aws" {
  region = "us-east-1"
  version = "~> 4.0"  # Use a version >= 4.0 to support object ownership controls
}

resource "aws_instance" "AWS-imported-VM" {
ami = "ami-0e2c8caa4b6378d8c"
instance_type = "t2.micro"
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "my-terraform-s3-bucket"

  bucket_ownership_controls {
    rule {
      object_ownership = "BucketOwnerEnforced"
    }
  }
}

