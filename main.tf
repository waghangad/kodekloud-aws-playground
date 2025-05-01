terraform {
  backend "s3" {
    bucket         = "tf-state-987654321"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf.lock"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "create_s3_bucket" {
  bucket = "kodekloud-playground-98754"
}


# EKS Auto mode 
# -------------

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = "study-eks-cluster"
  cluster_version = "1.31"

  # Optional
  cluster_endpoint_public_access = false

  cluster_addons = {

  }

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = "vpc-02e95af331064d625"
  subnet_ids = ["subnet-0f5c0cbe4f1683bb3", "subnet-02a67973d72bc49af"]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}