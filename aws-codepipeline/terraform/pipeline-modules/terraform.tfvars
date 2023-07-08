project_name       = "devops_pipeline_accelerator_test"
environment        = "dev"
backend_s3_bucket_arn = "arn:aws:s3:::tf-state-dpa"
backend_ddb_arn    = "arn:aws:dynamodb:us-east-1:316172404479:table/tf-state-dpa"
create_new_repo    = false
source_repo_name   = "devops_pipeline_accelerator"
source_repo_branch = "main"
common_repo_name   = "additional-repo"
common_repo_branch = "terraform"
crossaccount_role_arn = "arn:aws:iam::971033579102:role/pipelines_crossaccount_role"
repo_approvers_arn = "arn:aws:sts::316172404479:assumed-role/CodeCommitReview/*" #Update ARN (IAM Role/User/Group) of Approval Members
builder_image = "316172404479.dkr.ecr.us-east-1.amazonaws.com/dpa-terraform:al2"
build_projects = ["Build","Test","Pre-Deploy","Deploy","Post-Deploy","Destroy"]
create_new_role    = true
#codepipeline_iam_role_name = <Role name> - Use this to specify the role name to be used by codepipeline if the create_new_role flag is set to false.
stage_input = [
  { 
    name1 = "Build", 
    name = "Build", 
    category = "Build", 
    owner = "AWS", 
    provider = "CodeBuild", 
    input_artifacts = ["SourceOutput","SourceOutput1"], 
    output_artifacts = "BuildOutput",
    primary_source = "SourceOutput"
  },
  { 
    name1 = "Test", 
    name = "Test", 
    category = "Test", 
    owner = "AWS", 
    provider = "CodeBuild", 
    input_artifacts = ["SourceOutput","SourceOutput1"], 
    output_artifacts = "TestOutput"
    primary_source = "SourceOutput"
  },
  { 
    name1 = "Pre-Deploy", 
    name = "Pre-Deploy", 
    category = "Test", 
    owner = "AWS", 
    provider = "CodeBuild", 
    input_artifacts = ["SourceOutput","SourceOutput1"], 
    output_artifacts = "PreDepOutput"
    primary_source = "SourceOutput"
  },
  { 
    name1 = "Deploy", 
    name = "Deploy", 
    category = "Build", 
    owner = "AWS", 
    provider = "CodeBuild", 
    input_artifacts = ["SourceOutput","SourceOutput1"], 
    output_artifacts = "DepOutput"
    primary_source = "SourceOutput"
  },
  { 
    name1 = "Post-Deploy", 
    name = "Post-Deploy", 
    category = "Test", 
    owner = "AWS", 
    provider = "CodeBuild", 
    input_artifacts = ["SourceOutput","SourceOutput1"], 
    output_artifacts = "PostDepOutput"
    primary_source = "SourceOutput"
  },
  { 
    name1 = "Destroy", 
    name = "Destroy", 
    category = "Build", 
    owner = "AWS", 
    provider = "CodeBuild", 
    input_artifacts = ["SourceOutput","SourceOutput1"], 
    output_artifacts = "DestOutput"
    primary_source = "SourceOutput"
  }
]