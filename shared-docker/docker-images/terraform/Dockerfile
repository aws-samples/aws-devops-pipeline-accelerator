FROM amazonlinux:2

RUN yum update -y
RUN yum group install "Development Tools" -y
RUN yum install -y git zip wget
RUN yum install -y python3
RUN yum install -y python3-pip
RUN pip3 install --no-cache-dir setuptools==67.1.0
RUN pip3 install --no-cache-dir awscli

#install Terraform
ARG TERRAFORM_VERSION=1.4.6
ARG TARGETARCH=amd64
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN chmod +x terraform
RUN mv terraform /usr/local/bin/

COPY scripts/* /usr/local/bin/