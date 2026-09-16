output "instance_id" {
  value = aws_instance.web_server.id
}

# The instance sits in a private subnet with no public IP by design;
# it's reached through the ALB. Exposing private_ip instead of a
# (nonexistent) public_ip so this output actually resolves to something.
output "private_ip" {
  value = aws_instance.web_server.private_ip
}
