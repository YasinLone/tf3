resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "NAT_EIP"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_id

  tags = {
    Name = "Main_NAT_GW"
  }
}
