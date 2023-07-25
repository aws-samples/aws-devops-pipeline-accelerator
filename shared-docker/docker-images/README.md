# Docker image creation for using it in CodeBuild
This directory contains the Dockerfile and resources required to build the Docker image, which is used in the respective CodeBuild and Gitlab jobs. Using this custom image will speed up the Build install stage, which will be much faster than installing the binaries during the pipeline execution process.

## Requirements
1. Docker cli and docker engine should be installed and available.
2. An AWS Account with necessary permissions/roles to create Elastic Container Registry and push Docker image.

## Description
This directory contains multiple sub-directories based on the Infrastructure As a Code template binaries and base Docker image. 
1. The `base` directory contains the `Dockerfile` which is the dependency for other docker images, It contains all the essential binaries. If any additional tools or binaries are required, they can be added into this file.
2. The `cdk` directory contains `Dockerfile` which will create the Docker image that needs to be used with CDK IAC CodeBuild job or Gitlab. It contains the stage which will install the essential binaries.
3. The `cloudformation` directory contains `Dockerfile` which will create the Docker image that needs to be used with CloudFormation IAC CodeBuild job or Gitlab. It contains the stage which will install the essential binaries.
4. The `terraform` directory contains `Dockerfile` which will create the Docker image that needs to be used with Terraform IAC CodeBuild job or Gitlab. It contains the stage which will install the essential binaries.

## Usage
1. Create an [ECR repo](https://docs.aws.amazon.com/cli/latest/reference/ecr/create-repository.html) and get the ECR repo url.
2. Navigate to the `base` directory and build the base image by using below command. Update the `ECR Repo url` with the actual repo URL and update the `AWS Account No` and `region`
```sh
docker build -t baseimage:1

docker tag baseimage:1 <ECR Repo url>:1

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <AWS Account No>.dkr.ecr.<region>.amazonaws.com

docker push <ECR Repo url>:1
```

Repaet the above mentioned steps in the respectivesub directories to create the other docker images, based on the IAC tool you choose. 
Note: Please update the docker image tag and ECR repo url according to the directory.
