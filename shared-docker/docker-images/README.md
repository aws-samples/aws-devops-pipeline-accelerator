# Docker image creation for using it in CodeBuild
This directory contians Dockerfile and resources to build Docker image that needs to be used in the CodeBuild job which will be used as a base image. Using this custom image will save the CodeBuild install stage much faster than installing the binaries at the time of pipeline execution.

## Requirements
1. Docker cli and docker engine should be installed and available.
2. An AWS Account with necessary permissions/roles to create Elastic Container Registry and push Docker image.

## Description
This directory contains multiple sub directory based on the Infrastructure As a Code template binaries and base Docker image. The `base` directory contains the `Dockerfile` which is the dependency for other docker images, It contains all the essential binary, If any additional tools or binary needed it can be added in this file. 
The `cdk` directory contains `Dockerfile` which will create the Docker image that needs to be used with CDK IAC CodeBuild job or Gitlab, which contains the stage which will install the essantial binaries.
The `cloudformation` directory contains `Dockerfile` which will create the Docker image that needs to be used with CloudFormation IAC CodeBuild job or Gitlab, which contains the stage which will install the essantial binaries.
The `terraform` directory contains `Dockerfile` which will create the Docker image that needs to be used with Terraform IAC CodeBuild job or Gitlab, which contains the stage which will install the essantial binaries.

## Usage
Create a ECR repo and get the ECR repo url. Navigate to the `base` directory and build the base image by using below command. Update the `ECR Repo url` with the actual repo URL and update the `AWS Account No` and `region`
  ```sh
docker build -t baseimage:1

docker tag baseimage:1 <ECR Repo url>:1

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <AWS Account No>.dkr.ecr.<region>.amazonaws.com

docker push <ECR Repo url>:1
```

Follow the above mentioned steps to create the other docker images in the sub directories. Note: Please update the docker image tag and ECR repo url according to the directory.
