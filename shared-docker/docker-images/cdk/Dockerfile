#!/bin/bash
ARG VERSION=2.0.20230504.1

FROM amazonlinux:$VERSION
RUN yum update -y &&\
    yum install -y curl &&\
    curl -fsSL https://rpm.nodesource.com/setup_16.x | bash - &&\
    yum install -y nodejs --skip-broke &&\
    yum install -y awscli &&\
    yum install -y zip &&\
    yum install -y npm &&\
    npm install -g aws-cdk &&\
    npm install -g cdk-nag &&\
    npm install -g eslint &&\
    npm install -g prettier eslint-config-prettier eslint-plugin-prettier &&\
    npm install -g  aws-cdk-lib

COPY scripts/* /usr/local/bin/
RUN cdk --version
CMD ["bash"]
