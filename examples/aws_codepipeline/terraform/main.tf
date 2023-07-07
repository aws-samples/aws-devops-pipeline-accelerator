terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.20.1"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ec2_fg" {
  ami           = var.ami
  instance_type = var.instance_type
}
