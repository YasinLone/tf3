variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "public_subnet_availability_zone" {
  description = "AZ for the public subnet"
  type        = string
  default     = "ap-south-1a"
}

variable "private_subnet_availability_zone" {
  description = "AZ for the private subnet"
  type        = string
  default     = "ap-south-1b"
}

variable "ec2_ami_id" {
  description = "AMI ID for the EC2 instance (Amazon Linux 2 recommended - see ec2/main.tf user_data)"
  type        = string
  default     = "ami-0dee22c13ea7a9a67" # Example Amazon Linux 2 AMI for ap-south-1, update as needed
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
