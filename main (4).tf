# Provider configuration
provider "aws" {
  region = var.aws_region
}

# VPC Module
module "vpc" {
  source     = "./vpc"
  cidr_block = var.vpc_cidr_block
}

# Subnet Module
module "subnet" {
  source                           = "./subnet"
  vpc_id                           = module.vpc.vpc_id
  public_subnet_cidr               = var.public_subnet_cidr
  private_subnet_cidr              = var.private_subnet_cidr
  public_subnet_availability_zone  = var.public_subnet_availability_zone
  private_subnet_availability_zone = var.private_subnet_availability_zone
}

# Internet Gateway Module
module "internet_gateway" {
  source = "./igw"
  vpc_id = module.vpc.vpc_id
}

# NAT Gateway Module
module "nat_gateway" {
  source           = "./nat"
  public_subnet_id = module.subnet.public_subnet_id
}

# Route Table Module
module "route_table" {
  source              = "./route_table"
  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.internet_gateway.internet_gateway_id
  nat_gateway_id      = module.nat_gateway.nat_gateway_id
  public_subnet_id    = module.subnet.public_subnet_id
  private_subnet_id   = module.subnet.private_subnet_id
}

# Security Group Module (new - fixes the ALB having no security groups
# and the EC2 instance having none either)
module "security_group" {
  source = "./security_group"
  vpc_id = module.vpc.vpc_id
}

# EC2 Instance Module
module "ec2_instance" {
  source             = "./ec2"
  ami_id             = var.ec2_ami_id
  instance_type      = var.ec2_instance_type
  private_subnet_id  = module.subnet.private_subnet_id
  security_group_id  = module.security_group.ec2_sg_id
}

# Load Balancer Module
#
# NOTE: an internet-facing ALB (internal = false) must sit in subnets
# that route to an Internet Gateway. Only the public subnet qualifies;
# the private subnet does not and AWS will reject it at apply time.
# This repo only creates one subnet per tier, so the ALB is placed in
# the public subnet alone. For production, create a second public
# subnet in another AZ (e.g. ap-south-1b) so the ALB is properly
# multi-AZ, and pass both public subnet IDs here instead.
module "load_balancer" {
  source           = "./load_balancer"
  vpc_id           = module.vpc.vpc_id
  subnets          = [module.subnet.public_subnet_id]
  security_groups  = [module.security_group.alb_sg_id]
  ec2_instance_id  = module.ec2_instance.instance_id
}

output "load_balancer_dns_name" {
  value = module.load_balancer.load_balancer_dns_name
}

output "ec2_instance_private_ip" {
  value = module.ec2_instance.private_ip
}
