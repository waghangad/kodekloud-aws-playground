
terraform {
  backend "s3" {
    bucket         = "tf-state-gen-bucket-321"
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

# resource "aws_ecr_repository" "create_ecr_repo" {
#   name = "study/demo-repo"
#   image_tag_mutability = "IMMUTABLE"
#   visibility = "public"
#   image_scanning_configuration {
#     scan_on_push = false
#   }
# }


module "public_ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "study/demo-repo"
  repository_type = "public"

  repository_read_write_access_arns = ["arn:aws:iam::012345678901:role/terraform"]

  public_repository_catalog_data = {
    description       = "Docker container for some things"
    about_text        = file("${path.module}/files/ABOUT.md")
    usage_text        = file("${path.module}/files/USAGE.md")
    operating_systems = ["Linux"]
    architectures     = ["x86"]
    logo_image_blob   = filebase64("${path.module}/files/clowd.png")
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}



