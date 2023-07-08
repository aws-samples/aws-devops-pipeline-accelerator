#This solution, non-production-ready template describes AWS Codepipeline based CICD Pipeline for terraform code deployment.
#© 2022 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
#This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
#http://aws.amazon.com/agreement or other written agreement between Customer and either
#Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

variable "project_name" {
  description = "Unique name for this project"
  type        = string
}

variable "source_repo_name" {
  description = "Source repo name of the CodeCommit repository"
  type        = string
}

variable "source_repo_branch" {
  description = "Default branch in the Source repo for which CodePipeline needs to be configured"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name to be used for storing the artifacts"
  type        = string
}

variable "codepipeline_role_arn" {
  description = "ARN of the codepipeline IAM role"
  type        = string
}

variable "kms_key_arn" {
  description = "ARN of KMS key for encryption"
  type        = string
}

variable "tags" {
  description = "Tags to be attached to the CodePipeline"
  type        = map(any)
}

# variable "stages" {
#   description = "List of Map containing information about the stages of the CodePipeline"
#   type        = list(map(any))
# }
variable "stages" {
  description = "List of Map containing information about the stages of the CodePipeline"
  type        = list(object({
                  name = string
                  name1 = string
                  category = string
                  owner = string
                  provider = string, 
                  input_artifacts = list(string), 
                  output_artifacts = string,
                  primary_source = string
              }))
}

variable "approve_comment" {
  description = "List of Map containing information about the stages of the CodePipeline"
  type        = string
}

variable "common_repo_name" {
  description = "Common repo name of the CodeCommit repository"
  type        = string
}

variable "common_repo_branch" {
  description = "Default branch in the Common repo from which configurations needs to be read"
  type        = string
}