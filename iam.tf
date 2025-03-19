########################################
# EKS Cluster IAM Roles & Policies
########################################
locals {
    # The OIDC provider URL is required for EKS to enable IRSA
    eks_cluster_oidc_url       = aws_eks_cluster.data_analytics_cluster.identity.0.oidc.0.issuer
    # "The certificate data for the OIDC provider"
    tls_cert_sha1 = data.tls_certificate.oidc.certificates.0.sha1_fingerprint
}

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


########################################
# IRSA (IAM Roles for Service Accounts)
########################################
# An OIDC identity provider is required for EKS to enable IRSA.
# This allows K8s Service Accounts to assume IAM roles without hardcoding AWS credentials in the pod.
# EKS trusts the OIDC issuer URL from the cluster, and when a pod presents the correct service account token,
# AWS can verify it against that OIDC provider.


resource "aws_iam_openid_connect_provider" "eks_oidc" {
  url             = local.eks_cluster_oidc_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [local.tls_cert_sha1]
}


data "tls_certificate" "oidc" {
  url = local.eks_cluster_oidc_url
}


# Example IAM role for a specific service account (just an illustration)
resource "aws_iam_role" "irsa_example_role" {
  name               = "demo-irsa-example-role"
  assume_role_policy = data.aws_iam_policy_document.irsa_assume_role.json
}

data "aws_iam_policy_document" "irsa_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks_oidc.arn]
    }
    # This condition means the service account name is 'demo-analytics-app-sa' in the 'default' namespace
    condition {
      test     = "StringEquals"
      variable = "${replace(local.eks_cluster_oidc_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:demo-analytics-app-sa"]
    }
  }
}
