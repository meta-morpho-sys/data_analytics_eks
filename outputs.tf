output "eks_vpc_id" {
  value       = aws_vpc.eks_dev.id
  description = "The ID of the VPC for the EKS cluster" # A description of the output
}

