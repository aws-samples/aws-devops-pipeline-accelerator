# AWS CodePipeline for deploying CloudFormation resources
This folder contians the code and resources on how to build centralised templates for your infrastructure deployment pipeline using CloudFormation and AWS CodePipeline.

## Requirements
1. An AWS Account with necessary permissions/roles to create Codecommit Repositories and CodePipeline components.
2. To deploy this solution we suggest to have 2 separate CodeCommit repositories
     * First repository will contain the shared libraries, buildspec file and dependencies. Lets call this as the `common-repo`
     * Second repository will contain the CloudFormation templates to deploy your infrastructure. Lets call this the `app-repo`

## Usage
This folder contains below 2 directories:
 * `pipeline-modules`   ## The CloudFormation code to to deploy the Standardized Pipeline
 * `shared`             ## the Ready-to-use Buildspec files.

To begin with:
1. Create a folder named shared and copy all the Buildspec files from the `shared` folder into the `common-repo/` folder
2. In the `app-repo`, create a folder named `entrypoint` and copy the file .\examples\aws_codepipeline\cloudformation\entrypoint\config.json into it.
3. Refer to the `.\examples\aws_codepipeline\cloudformation` folder for the struture. Please note that using this example we are creating S3 buckets.
4. You can clone this repository and use the templates under `pipeline-modules` to setup your pipeline


## Explanation of the `config.json` file:
This is the main config file, where you can customize and enable/disable a stage. Please note that if the stage is disbaled, it will just be skip the execution, but not delete/remove the stage from the Pipeline.
```json
{
    "init_stage_required" : "true",
    "test_stage_required" : "true",
    "createinfra_stage_required": "true",
    "envType" : "cloudformation",
    "stage_required" : "true",
    "cft_s3_bucket" : "pipeline-bucket",               #S3 bucket from the destination account to keep CFT templates
    "stack_name" : "aws-cft-poc",                      #CloudFormation stack name
    "account" : "************",                        #Destination AWS account to deploy stack
    "roleName" : "codestack-poc-cross-account-role",   #Cross account IAM role name
    "region" : "us-east-1",
    "destroy_stack" : "false"                          #To destroy the provisioned stack this value set to be "true"
}
```

## Creating Pipeline with all the Stages defined
Once we have the information filled then we are good to go with Pipeline creation. To create the pipeline we need to use the “pipeline-cft.yaml” file. Please deploy the CloudFormation template, below mentioned are the necessary Parameters to be passed to the stack.

  ArtifactsBucket:
    Description: Name of the repo where the pipeline artifacts to be updated contains.
  EcrDockerRepository:
    Description: ECR Docker repository name for the CodeBuild image
  CodeCommitAppRepo:
    Description: CodeCommit repository name which contains the templates
  CodeCommitBaseRepo:
    Description: CodeCommit repository name which contains the shared files
  CodeCommitRepoBranch:
    Description: CodeCommit repository branch name
  SNSMailAddress:
    Description: email address to receive SNS notification for pipeline approval.


* After this login to the AWS account and you should see the new pipeline created. Note: If she first run is in failed state, just re-excute it once more.
* Add necessary permissions to the new IAM Role created for CodeBuild. For e.g. the Cross Account IAM Role should have permissions to create S3 buckets as per the Terrraform template in the examples directory.

