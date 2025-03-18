######
# A centralised Terraform State to avoid deployment conflicts.
######

terraform {
  backend "s3" {
    bucket       = "yuliya-tf-study-state"
    key          = "eks-analytics.terraform.tfstate"
    region       = "eu-west-1"
    use_lockfile = true
    encrypt      = true
    profile      = "interview-prep"
  }
}