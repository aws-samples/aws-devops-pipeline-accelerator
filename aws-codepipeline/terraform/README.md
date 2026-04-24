# AWS CodePipeline for deploying Terraform IAC resources
This directory contains the code and resources on how to build centralised templates for your infrastructure deployment pipeline using ***Terraform and AWS CodePipeline***.

## Requirements
1. An AWS Account with necessary permissions/roles to create Codecommit Repositories and CodePipeline components.
2. To deploy this solution we suggest to have 2 separate CodeCommit repositories
     * First repository will contain the shared libraries, buildspec file and dependencies. 
        Lets call this as the `common-repo`
     * Second repository will contain the Terraform templates to deploy your infrastructure. 
        Lets call this the `app-repo`

## Usage
This folder contains below 2 directories:
 * `pipeline-modules`   ## The Terraform code to to deploy the Standardized Pipeline structure
 * `shared`             ## the Ready-to-use Buildspec files.

To begin with:
1. In the `common-repo`, create a folder named `shared` and copy all the Buildspec files from the `shared` folder into the `common-repo/shared` folder.
2. In the `app-repo`, create a folder named `entrypoint` and copy the file `.\examples\aws_codepipeline\terraform\entrypoint\terraform-infrastructure.json` into it.
3. Refer to the `.\examples\aws_codepipeline\terraform` folder for the struture. 
   Please note that in this example, we are creating an EC2 instance defined in the main.tf file.
4. Clone this Github repository and use the templates under `pipeline-modules` to setup your pipeline as **[described here](#Creating Pipeline with all the Stages defined)**


## Explanation of the `terraform-infrastructure.json` file:
This is the main config file, where you can customize and enable/disable a stage. Please note that if the stage is disbaled, it will just be skip the execution, but not delete/remove the stage from the Pipeline.
```json
{
    "build_stage_required" : "true",
    "test_stage_required" : "true",
    "predeploy_stage_required": "true",
    "deploy_stage_required": "true",
    "postdeploy_stage_required": "true",
    "destroy_stage_required": "true",
    "bucket":"tf-state-dpa",                # S3 bucket used for Terraform backend
    "key":"terraform_test.tfstate",         # S3 key to be used
    "region":"us-east-1",
    "use_lockfile":"true"                   # Enable S3 native state locking (Terraform >= v1.11.0)
}
```

## Creating Pipeline with all the Stages defined
* Update and validate the `pipeline-modules/terraform.tfvars`
* Create a Docker image as directed here and update the **builder_image** variable defined in `pipeline-modules/terraform.tfvars`
* Execute below commands :
    * terraform init
    * terraform plan
    * terraform apply
* After this login to the AWS account and you should see the new pipeline created. Note: If the first run is in failed state, just re-excute it once more.
* Add necessary permissions to the new IAM Role created for CodeBuild. For e.g. The CodeBuild Role should have permissions to create EC2 instance (as per the Terrraform template in the examples directory).

## Tools
- **[Checkov](https://github.com/bridgecrewio/checkov)** - Checkov is a static code analysis tool for infrastructure as code (IaC). It scans cloud infrastructure templates for Terraform, CDK and CloudFormation and detects security and compliance misconfigurations.
- **[TFLint](https://github.com/terraform-linters/tflint)** - TFLint is a linter checking potential Terraform errors and enforcing best practices.
- **[TFSec](https://github.com/aquasecurity/tfsec)** - Static analysis of your Terraform code to spot potential misconfigurations.

## Migrating from DynamoDB State Locking to S3 Native Locking

As of Terraform v1.11.0, DynamoDB-based state locking is deprecated. This repository has been updated to use S3 native locking (`use_lockfile = true`), which uses S3 conditional writes to create a `.tflock` file alongside your state file.

If you have already deployed infrastructure based on a previous version of this repository that used `dynamodb_table` for state locking, follow these steps to migrate:

### Prerequisites

- Update Terraform to **v1.11.0 or later** (`terraform version` to verify)

### Step 1: Enable Dual Locking

In your backend configuration, add `use_lockfile = true` while keeping the existing `dynamodb_table` setting:

```hcl
backend "s3" {
  bucket         = "your-state-bucket"
  key            = "terraform.tfstate"
  region         = "us-east-1"
  dynamodb_table = "your-lock-table"  # Keep temporarily
  use_lockfile   = true                # Add this
  encrypt        = true
}
```

Run `terraform init -reconfigure` to apply the change. Terraform will acquire locks from both S3 and DynamoDB before proceeding with any operations.

### Step 2: Verify

Run `terraform plan` and `terraform apply` a few times to confirm that S3 native locking works correctly alongside DynamoDB locking.

### Step 3: Remove DynamoDB Configuration

Once verified, remove the `dynamodb_table` argument from your backend configuration and the `-backend-config="dynamodb_table=..."` from your buildspec files or scripts. Run `terraform init -reconfigure` again.

The DynamoDB table can be deleted after confirming all environments have been migrated.

### Important Notes

- **Terraform v1.11.0 or later is required.** The `use_lockfile` argument is not recognized by earlier versions and will cause an error. If your team uses mixed Terraform versions, keep Dual Locking (Step 1) until everyone has upgraded.
- **S3-compatible storage (e.g., MinIO):** S3 native locking relies on conditional writes (`If-None-Match` header), which may not be supported by all S3-compatible storage providers.

For more details, see [HashiCorp S3 Backend Documentation](https://developer.hashicorp.com/terraform/language/backend/s3).
