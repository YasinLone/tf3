resource "aws_lb" "app_lb" {
  name                              = "app-lb"
  internal                          = false
  load_balancer_type                = "application"
  security_groups                   = var.security_groups
  subnets                           = var.subnets
  enable_deletion_protection        = false
  idle_timeout                      = 3600
  enable_cross_zone_load_balancing  = true
}

resource "aws_lb_target_group" "target_group" {
  name     = "target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  # Forward to the target group instead of returning a static
  # fixed-response, so traffic actually reaches the EC2 instance.
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "web_server" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = var.ec2_instance_id
  port              = 80
}
