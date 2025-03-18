########################################
# VPC & Networking
########################################

# Create a VPC for EKS cluster
resource "aws_vpc" "eks_dev" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "eks-dev"
      Project = var.project
    }
}

# Public subnets in 3 AZs
resource "aws_subnet" "public_a" {
  vpc_id = aws_vpc.eks_dev.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "eks-public-a"
    Project = var.project
  }
}

resource "aws_subnet" "public_b" {
  vpc_id = aws_vpc.eks_dev.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.region}b"
  map_public_ip_on_launch = true
  tags = {
    Name = "eks-public-b"
    Project = var.project
  }
}

resource "aws_subnet" "public_c" {
  vpc_id = aws_vpc.eks_dev.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.region}c"
  map_public_ip_on_launch = true
  tags = {
    Name = "eks-public-c"
    Project = var.project
  }
}

# Private subnets in 3 AZs
resource "aws_subnet" "private_a" {
  vpc_id = aws_vpc.eks_dev.id
  cidr_block = "10.0.100.0/24"
  availability_zone = "${var.region}a"
  tags = {
    Name = "eks-private-a"
    Project = var.project
  }
}

resource "aws_subnet" "private_b" {
  vpc_id = aws_vpc.eks_dev.id
  cidr_block = "10.0.101.0/24"
  availability_zone = "${var.region}b"
  tags = {
    Name = "eks-private-b"
    Project = var.project
  }
}

resource "aws_subnet" "private_c" {
  vpc_id = aws_vpc.eks_dev.id
  cidr_block = "10.0.102.0/24"
  availability_zone = "${var.region}c"
  tags = {
    Name = "eks-private-c"
    Project = var.project
  }
}

# Internet Gateway
resource "aws_internet_gateway" "eks_dev" {
    vpc_id = aws_vpc.eks_dev.id
    tags = {
      Name = "eks-dev-igw"
      Project = var.project
    }
}
