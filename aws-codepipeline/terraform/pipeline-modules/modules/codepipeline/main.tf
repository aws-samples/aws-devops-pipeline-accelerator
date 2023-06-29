#This solution, non-production-ready template describes AWS Codepipeline based CICD Pipeline for terraform code deployment.
#© 2022 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
#This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
#http://aws.amazon.com/agreement or other written agreement between Customer and either
#Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_codepipeline" "terraform_pipeline" {
  name     = "${var.project_name}-pipeline"
  role_arn = var.codepipeline_role_arn
  tags     = var.tags

  artifact_store {
    location = var.s3_bucket_name
    type     = "S3"
    encryption_key {
      id   = var.kms_key_arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"
    action {
      name             = "Init"
      category         = "Source"
      owner            = "AWS"
      version          = "1"
      provider         = "CodeCommit"
      namespace        = "SourceVariables"
      output_artifacts = ["SourceOutput"]
      run_order        = 1

      configuration = {
        RepositoryName       = var.source_repo_name
        BranchName           = var.source_repo_branch
        PollForSourceChanges = "false"
      }
    }
  
    action {
      name             = "Init1"
      category         = "Source"
      owner            = "AWS"
      version          = "1"
      provider         = "CodeCommit"
      namespace        = "SourceVariables1"
      output_artifacts = ["SourceOutput1"]
      run_order        = 1

      configuration = {
        RepositoryName       = var.common_repo_name
        BranchName           = var.common_repo_branch
        PollForSourceChanges = "false"
      }
    }
  }

  dynamic "stage" {
    for_each = var.stages

    content {
      name = stage.value["name1"]
      action {
        category         = stage.value["category"]
        name             = stage.value["name1"]
        owner            = stage.value["owner"]
        provider         = stage.value["provider"]
        input_artifacts  = stage.value["input_artifacts"]
        output_artifacts = [stage.value["output_artifacts"]]
        version          = "1"
        run_order        = index(var.stages, stage.value) + 2

        configuration = {
          ProjectName = stage.value["provider"] == "CodeBuild" ? "${var.project_name}-${stage.value["name"]}" : null
          PrimarySource = stage.value["primary_source"]
        }
      }
    }
  }

  stage {
    name = "Approve"

    action {
      name     = "Approval"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"
      configuration = {
        CustomData = "${var.approve_comment}"
      }
    }
  }

  stage {
    name = "DeployToTest"
    action {
      name     = "DeployToTest"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"
      input_artifacts = ["SourceOutput","SourceOutput1"]
      output_artifacts = ["DeployToTestOutput"]
      run_order = "6"
      configuration = {
        ProjectName = "${var.project_name}-apply"
        PrimarySource = "SourceOutput"
      }
    }
  }
}

# Listen for activity on the CodeCommit repo and trigger the CodePipeline
data "aws_codecommit_repository" "source_repo" {
  repository_name = "${var.source_repo_name}"
}
data "aws_codecommit_repository" "common_repo" {
  repository_name = "${var.common_repo_name}"
}

locals {
  codecommit_repo_arn = data.aws_codecommit_repository.source_repo.arn
  common_repo_arn = data.aws_codecommit_repository.common_repo.arn
}

resource "aws_cloudwatch_event_rule" "codecommit_cwe" {
  name_prefix = "${var.common_repo_name}-${var.common_repo_branch}-cwe"
  description = "Detect commits to CodeCommit repo of ${var.common_repo_name} on branch ${var.common_repo_branch}"

  event_pattern = <<PATTERN
{
  "source": [ "aws.codecommit" ],
  "detail-type": [ "CodeCommit Repository State Change" ],
  "resources": [ "${local.common_repo_arn}"],
  "detail": {
     "event": [
       "referenceCreated",
       "referenceUpdated"
      ],
     "referenceType":["branch"],
     "referenceName": ["${var.common_repo_branch}"]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "cloudwatch_triggers_pipeline" {
  target_id = "${var.common_repo_branch}-commits-trigger-pipeline"
  rule = aws_cloudwatch_event_rule.codecommit_cwe.name
  arn = aws_codepipeline.terraform_pipeline.arn
  role_arn = aws_iam_role.cloudwatch_ci_role.arn
}

# Allows the CloudWatch event to assume roles
resource "aws_iam_role" "cloudwatch_ci_role" {
  name_prefix = "${var.common_repo_branch}-cw-ci-"

  assume_role_policy = <<DOC
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
DOC
}

data "aws_iam_policy_document" "cloudwatch_ci_iam_policy" {
  statement {
    actions = ["iam:PassRole"]
    resources = ["*"]
  }
  statement {
    actions = ["codepipeline:StartPipelineExecution"]
    resources = [aws_codepipeline.terraform_pipeline.arn]
  }
}

resource "aws_iam_policy" "cloudwatch_ci_iam_policy" {
  name_prefix = "${var.common_repo_branch}-cw-ci-"
  policy = data.aws_iam_policy_document.cloudwatch_ci_iam_policy.json
}
resource "aws_iam_role_policy_attachment" "cloudwatch_ci_iam" {
  policy_arn = aws_iam_policy.cloudwatch_ci_iam_policy.arn
  role = aws_iam_role.cloudwatch_ci_role.name
}