output "eks_vpc_id" {
  value       = aws_vpc.eks_dev.id
  description = "The ID of the VPC for the EKS cluster" # A description of the output
}

output "eks_cluster_url" {
  value       = aws_eks_cluster.data_analytics_cluster.endpoint
  description = "The URL of the EKS cluster" # A description of the output
}

