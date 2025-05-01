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