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



########################################
# EKS Managed Node Groups
########################################

# CPU-intensive node group
resource "aws_eks_node_group" "cpu" {
  cluster_name    = aws_eks_cluster.data_analytics_cluster.name
  node_group_name = "dac_cpu-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [aws_subnet.private_a.id, aws_subnet.private_b.id, aws_subnet.private_c.id]

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 4
  }

  # Common instance type for general compute
  instance_types = ["m5.xlarge"]

  depends_on = [
    aws_eks_cluster.data_analytics_cluster,
    aws_iam_role_policy_attachment.eks_node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_node_AmazonEC2ContainerRegistryReadOnly
  ]

  tags = {
    Name = "dac-cpu-node-group"
    Project = var.project
  }
}



# GPU-accelerated node group (optional, set desired_size=0 if you only need on-demand)
resource "aws_eks_node_group" "gpu" {
  cluster_name    = aws_eks_cluster.data_analytics_cluster.name
  node_group_name = "gpu-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [aws_subnet.private_a.id, aws_subnet.private_b.id]

  scaling_config {
    desired_size = 0
    min_size     = 0
    max_size     = 2
  }

  # P2, P3, G4, etc. (change to match your ML/compute needs)
  instance_types = ["p2.xlarge"]

  depends_on = [
    aws_eks_cluster.data_analytics_cluster,
    aws_iam_role_policy_attachment.eks_node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_node_AmazonEC2ContainerRegistryReadOnly
  ]

  tags = {
    Name = "dac-gpu-node-group"
    Project = var.project
  }
}