# Data Analytics EKS Cluster

This repository contains the code to create an EKS cluster with a managed node group using Terraform.
It is based on a case study for an interview process.


It is a template which sets up the basic infrastructure for an EKS cluster with a managed node group. 
It also creates a VPC, subnets, security groups, IAM roles and integrates an OIDC provider.

To-Do:
1. IRSA Usage:
* Create Kubernetes service accounts annotated with the IAM role ARN (e.g., eks.amazonaws.com/role-arn: arn:aws:iam::123456789012:role/demo-irsa-example-role). 
This lets specific workloads access S3, DynamoDB, or Redshift directly without storing credentials in pods.
2. Deploy Analytics/Orchestration Applications: 
   * Spark Operator,
   * ArgoCD,
   * Airflow, or Kafka via Helm, referencing these private subnets and using IRSA for secure AWS access.
3. Cluster Autoscaling: 
   * Install the Kubernetes Cluster Autoscaler (via Helm) and associate it with the node groups to automatically scale nodes up/down based on workload.