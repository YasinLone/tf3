variable "subnets" {
  description = "Subnets to deploy the load balancer into"
  type        = list(string)
}

variable "security_groups" {
  description = "Security group IDs to associate with the load balancer"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "ec2_instance_id" {
  description = "EC2 instance ID to attach to the target group"
  type        = string
}
