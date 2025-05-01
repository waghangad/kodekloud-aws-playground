
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

# S3 bucket
# ----------

resource "aws_s3_bucket" "create_s3_bucket" {
  bucket = "kodekloud-playgroud-19345"
}



