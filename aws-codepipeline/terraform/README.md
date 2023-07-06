# AWS CodePipeline for deploying Terraform resources
This folder contians the code and resources on how to build centralised templates for your infrastructure deployment pipeline using Terraform and AWS CodePipeline.

## Requirements
1. An AWS Account with necessary permissions/roles to create Codecommit Repositories and CodePipeline components.
2. To deploy this solution we suggest to have 2 separate CodeCommit repositories
 * First repository will contain the shared libraries, buildspec file and dependencies. Lets call this as the `common-repo`
 * Second repository will contain the Terraform templates to deploy your infrastructure. Lets call this the `app-repo`

## Usage
This folder contains below 2 directories:
 * `pipeline-modules`   ## The Terraform code to to deploy the Standardized Pipeline
 * `shared`             ## the Ready-to-use Buildspec files.

To begin with:
1. Create a folder named shared and copy all the Buildspec files from the `shared` folder into the `common-repo/shared` folder
2. In the `app-repo`, create a folder named `entrypoint` and copy the file .\examples\aws_codepipeline\terraform\entrypoint\terraform-infrastructure.json into it.
3. Refer to the `.\examples\aws_codepipeline\terraform` folder for the struture. Please note that using this example we are creating an EC2 instance defined in the main.tf file.
4. You can clone this repository and use the templates under `pipeline-modules` to setup your pipeline


## Explanation of the `terraform-infrastructure.json` file:
This is the main config file, where you can customize and enable/disable a stage. Please note that if the stage is disbaled, it will just be skip the execution, but not delete/remove the stage from the Pipeline.
```json
{   
    "build_stage_required" : "true",
    "test_stage_required" : "true",
    "publish_stage_required": "false",
    "predeploy_stage_required": "false",
    "deploy_stage_required": "false",
    "postdeploy_stage_required": "false",
    "destroy_stage_required": "false",
    "deploytoprod_stage_required": "true",
    "bucket":"tf-state-dpa",                    ## The 
    "key":"terraform.tfstate",
    "region":"us-east-1",
    "dynamodb_table":"tf-state-dpa"
}
```

## Creating Pipeline with all the Stages defined
* Update the `pipeline-modules/terraform.tfvars` 
* Execute terraform init
* terraform plan