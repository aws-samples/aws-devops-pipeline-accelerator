# DevOps Pipeline Accelerator (DPA)

This repository contains the code and resources on how to build centralised templates for your infrastructure deployment pipeline, for various types of Infrastructure as a Code Tools. These templates can be consumed by various teams to orchestrate their Infrastructure build and deployment pipelines with the standard/basic required configurations. 
This will help the teams to focus more on developing features than working on building pipelines for the deployment.

## Table of content
 * [Principles of DPA](#Principles of DPA)
 * [Requirements](#prerequisites)
 * [Architecture](#architecture)
 * [Deployment](#deployment)
 * [Benefits](#benefits)
 * [Limitations](#limitations)

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

## Requirements

1. An AWS Account with necessary permissions/roles that will be used to provision resources using IaC templates

## Architecture

## Deployment

1. [AWS CodePipeline for deploying Terraform resources](https://github.com/aws-samples/aws-devops-pipeline-accelerator/blob/feature/repo-structure/aws-codepipeline/terraform/README.md)
2. 



## Benefits

## Limitations

## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License
This library is licensed under the MIT-0 License. See the LICENSE file.

## Contributors
* Ashish Bhat
* Eknaprasath P
* Mayuri Patil
* Ruchika Modi
