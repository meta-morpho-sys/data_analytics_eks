# NAT Gateway for private subnets
resource "aws_eip" "nat" {
  depends_on = [aws_internet_gateway.eks_dev]
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_a.id
  tags = {
    Name    = "eks-nat"
    Project = var.project
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.eks_dev.id
  tags = {
    Name    = "eks-private-rt"
    Project = var.project
  }
}

resource "aws_route_table_association" "private_rt_assoc_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_assoc_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_assoc_c" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}