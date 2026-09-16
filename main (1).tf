resource "aws_instance" "web_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.security_group_id]

  # NOTE: this assumes an Amazon Linux 2 AMI (yum + httpd), matching the
  # AMI id used in root main.tf. If you switch to an Ubuntu AMI, change
  # this to: apt update -y && apt install -y apache2 && systemctl enable --now apache2
  user_data = <<-EOT
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "Hello, World!" > /var/www/html/index.html
  EOT

  tags = {
    Name = "Private_EC2_Instance"
  }
}
