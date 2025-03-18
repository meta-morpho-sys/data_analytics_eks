########################################
# EKS Cluster IAM Roles & Policies
########################################

# EKS Cluster Service Role
resource "aws_iam_role" "eks_cluster" {
  name               = "eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_trust_policy.json
}

data "aws_iam_policy_document" "eks_cluster_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["eks.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  name       = "eks-cluster-AmazonEKSClusterPolicy"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  roles      = [aws_iam_role.eks_cluster.name]
}