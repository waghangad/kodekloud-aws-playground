
terraform {
  backend "s3" {
    bucket         = "tf-state-gen-bucket-637423280582-us-east-1"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf.lock"
  }
}

provider "aws" {
  region = "us-east-1"
}

# S3 bucket
# ----------

resource "aws_s3_bucket" "create_s3_bucket" {
  bucket = "kodekloud-plygroud-19345"
}

resource "aws_ecr_repository" "create_ecr_repo" {
  name = "study/demo-repo"
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = false
  }
}



