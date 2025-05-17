variable "name" {
  description = "Name prefix for VPC resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDRs for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDRs for private subnets"
  type        = list(string)
}

variable "az_suffixes" {
  description = "Mapping of index to AZ suffix (e.g. 0 = a, 1 = b)"
  type        = map(string)
  default     = {
    0 = "a"
    1 = "b"
    2 = "c"
  }
}

variable "tags" {
  description = "Global tags"
  type        = map(string)
  default     = {}
}
