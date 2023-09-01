# DevOps Pipeline Accelerator (DPA)

This repository contains the code and resources on how to build centralised templates for your infrastructure deployment pipeline, for various types of Infrastructure as a Code Tools. These templates can be consumed by various teams to orchestrate their Infrastructure build and deployment pipelines with the standard/basic required configurations. 
This will help the teams to focus more on developing features than working on building pipelines for the deployment.

## Table of content
 * [Principles of DPA](#principles)
 * [Prerequisites](#prerequisites)
 * [Architecture](#architecture)
 * [Deployment](#deployment)
 * [Benefits](#benefits)
 * [Limitations](#limitations)

## Principles
1. Deployments to environments must be consistent and use same artifacts for deployment
2. Each job in pipeline should run in specific Docker containers
3. DPA has been designed to work with feature branch based branching model

DPA contains below few important modules in code :

### Entrypoints
Entrypoints in DPA represets specific IaC pipeline strating point that will be consumed by application. Entrypoint consists of aggregators and various stages.
This is the Configuration file which you need to add in your Application Repository and used for Customizing the various pre-defined stages.

***Example Entrypoint files :***
1. https://github.com/aws-samples/aws-devops-pipeline-accelerator/blob/feature/repo-structure/examples/aws_codepipeline/terraform/entrypoint/terraform-infrastructure.json
2. https://github.com/aws-samples/aws-devops-pipeline-accelerator/blob/feature/repo-structure/gitlab-ci/entrypoints/terraform-infrastructure.yml

### Aggregators
Aggregators in DPA is a collection of jobs managed by stages, there are multiple wrappers that forms entrypoint for specific IaC pipeline.

### Stages
Stages contain actual building blocks that form the jobs inside stages. Each stage represent specific execution of pipeline jobs.
***Default Stages provisioned for a Single Environment (dev) are mentioned below***. You can customize the pre-defined stages in the Entrypoint configuration provided above. And this is explained in detail in the Deployment Section for individual types of Deployment below. (Please follow the links as per your requirements)
1. Init
2. Build
3. Test
4. PreDeploy, Package, Publish
5. Deploy
6. Verify
7. Manual Approval
8. Destroy

## Prerequisites 

1. An AWS Account with necessary permissions/roles that will be used to provision resources using IaC templates
2. Docker Image created and pushed to ECR as [outlined here](https://github.com/aws-samples/aws-devops-pipeline-accelerator/blob/feature/repo-structure/shared-docker/docker-images/README.md)

## Architecture
<img width="947" alt="image" src="https://github.com/aws-samples/aws-devops-pipeline-accelerator/assets/106240341/217c927d-3e1d-4f95-8cce-34560da9ea0d">

## Deployment
1. [AWS CodePipeline for deploying Terraform resources](https://github.com/aws-samples/aws-devops-pipeline-accelerator/blob/feature/repo-structure/aws-codepipeline/terraform/README.md)
2. [AWS CodePipeline for deploying CloudFormation resources](https://github.com/aws-samples/aws-devops-pipeline-accelerator/blob/feature/repo-structure/aws-codepipeline/terraform/README.md)
3. [Gitlab CI for deploying Terraform, CDK and CloudFormation resources](https://github.com/aws-samples/aws-devops-pipeline-accelerator/blob/feature/repo-structure/gitlab-ci/README.md)

## Benefits
1. ***Standardisation & consistency*** : standardised pipeline for any type of application brings in consistency in application deployment
2. ***Reusability*** : Entire solution is reusable and scalable in nature. Accelerators can be consumed by applications to orchestrate pipeline
3. ***Velocity*** : Application team can focus more on to developing app than worrying about building pipeline of the application that will be improve velocity of application
4. ***Security*** : Built in quality gates that secures quality of the application deployment with DevSecOps concepts
5. ***Scalability*** : Outcome of this entire solution would be configurable templates which are highly scalable and can easily integrate with any type of application that supports CI/CD pipeline for chosen platform.

## Limitations
1. First release supports (provides reuasble code) only for AWS CodePipeline and Gitlab CI platforms.

## Security
See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License
This library is licensed under the MIT-0 License. See the LICENSE file.

## Contributors
* Ashish Bhat
* Eknaprasath P
* Mayuri Patil
* Ruchika Modi
