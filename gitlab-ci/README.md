# GitLab CI for deploying Terraform, CDK and CloudFormation IaC templates
This directory contians GitLab templates as building blocks for deploying Terrafrom, CDK and CloudFormation IaC code.

It contains: 
- Standardised pipeline structure
- Reusable stages and jobs
- Pipeline structure rules
- Integrated tools for security scans

## Principles of DPA
1. Deployments to environments must be consistent and use same artifacts for deployment
2. Each job in pipeline should run in specific Docker containers
3. DPA has been designed to work with feature branch based branching model

DPA contains below few important modules in code :

## Entrypoints

Entrypoints in DPA represets specific IaC pipeline strating point that will be consumed by application. Entrypoint consists of aggregators and various stages.

## Aggregators

Aggregators in DPA is collection of jobs managed by stages, there are multiple  wrappers that forms entrypoint for specific IaC pipeline.

## Stages

Stages contain actual building blocks that form the jobs inside stages. Each stage represent specific execution of pipeline jobs.

## Prerequisites / Requirements

1. An AWS Account with necessary permissions/roles that will be used to provision resources using IaC templates
2. GitLab account with any type of licence free, premium or enterprise that supports GitLab CI/CD features
3. GitLab required runners configured to run jobs with specific docker images

## Tools
- **[Checkov](https://github.com/bridgecrewio/checkov)** - Checkov is a static code analysis tool for infrastructure as code (IaC). It scans cloud infrastructure templates for Terraform, CDK and CloudFormation and detects security and compliance misconfigurations.
- **[Kics](https://github.com/Checkmarx/kics)** - Kics stands for **K**eep **I**nfrastrcuture as **C**ode **S**ecure which is open source cloud native project. It helps to find security vulnerabilities, compliance issues and infrastructure misconfigurations early in the development cycle.
- **[TFSec](https://github.com/aquasecurity/tfsec)** - Static analysis of your Terraform code to spot potential misconfigurations.
- **[CDK Nag](https://github.com/cdklabs/cdk-nag)** - Check CDK applications for best practices using a combination of available rule packs
- **[CFN Lint](https://github.com/aws-cloudformation/cfn-lint)** -  Linter that validates AWS CloudFormation yaml/json templates
- **[CFN Nag](https://github.com/stelligent/cfn_nag)** - The cfn-nag tool looks for patterns in CloudFormation templates that may indicate insecure infrastructure


  
## Usage
In order to use DPA GitLab standardised pipelines for IaC templates below steps to be performed.
1. Copy `gitlab-ci` directory and host it to your gitlab organisation group
2. Make sure group where you create repository with DPA templates are accessible by other applications where pipeline needs to be constructed
3. At consumer application, include DPA specific entrypoint for IaC pipeline execution 
    - ### Terraform

    ``` yml
      include:
          - project: <GITLAB_GROUP_PATH/<REPOSITORY_NAME>
            ref: main # best practise to create release tag and use the same 
            file: gitlab-ci/entrypoints/gitlab/terraform-infrastructure.yml
    ```
    - ### CDK

    ``` yml
      include:
          - project: <GITLAB_GROUP_PATH/<REPOSITORY_NAME>
            ref: main # best practise to create release tag and use the same 
            file: gitlab-ci/entrypoints/gitlab/cdk-infrastructure.yml
    ```
    - ### CloudFormation

    ``` yml
      include:
          - project: <GITLAB_GROUP_PATH/<REPOSITORY_NAME>
            ref: main # best practise to create release tag and use the same 
            file: gitlab-ci/entrypoints/gitlab/cf-infrastructure.yml
    ```
4. Below are variables to be defined at application in roder to have deployment enabled on DEV and INTEGRATION environments
   
   ``` yml
     AWS_REGION: us-east-2 # region where deployment should happen
     DEV_AWS_ACCOUNT: ************ # Dev environment AWS account number
     DEV_ARN_ROLE: arn:aws:iam::************:role/dpa-gitlab-access-role # Role ARN that will be used to provision resources in Dev 
     DEV_DEPLOY: "true" # true / false to enable deployment to DEV environment
     DEV_ENV: "dev" # Dev environment name
     INT_AWS_ACCOUNT: ************ # Integration environment AWS account number
     INT_ARN_ROLE: arn:aws:iam::************:role/dpa-gitlab-access-role # Role ARN that will be used to provision resources in Integration 
     INT_DEPLOY: "true" # true / false to enable deployment to DEV environment
     INT_ENV: "int" # Dev environment name
   ```
