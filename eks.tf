########################################
# EKS Cluster
########################################

resource "aws_eks_cluster" "data_analytics_cluster" {
  name     = "data-analytics-cluster"
  role_arn = aws_iam_role.eks_cluster.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids              = [aws_subnet.private_a.id, aws_subnet.private_b.id, aws_subnet.private_c.id]
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  depends_on = [aws_iam_policy_attachment.eks_cluster_AmazonEKSClusterPolicy]

  tags = {
    Name    = "data-analytics-cluster"
    Project = var.project
  }
}