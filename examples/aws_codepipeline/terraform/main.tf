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
    #checkov:skip=CKV_AWS_8:Ensure all data stored in the Launch configuration or instance Elastic Blocks Store is securely encrypted
    #checkov:skip=CKV_AWS_126:Ensure that detailed monitoring is enabled for EC2 instances
    #checkov:skip=CKV_AWS_135:Ensure that EC2 is EBS optimized
    #checkov:skip=CCKV_AWS_79:Ensure Instance Metadata Service Version 1 is not enabled
    #checkov:skip=CCKV2_AWS_41:Ensure an IAM role is attached to EC2 instance
  instance_type = var.instance_type
  
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
}
