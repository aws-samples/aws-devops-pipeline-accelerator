ARG AL2VERSION=2.0.20230504.1

FROM amazonlinux:${AL2VERSION}
RUN yum update -y &&\
    yum install -y git zip jq aws-cli gcc gcc-c++ make openssl-devel zlib-devel tar

RUN yum install -y python3
RUN yum install -y python3-pip

RUN pip3 install --no-cache-dir setuptools==67.1.0
RUN pip3 install --no-cache-dir cfn-lint
RUN pip3 install --no-cache-dir pydot

# Download and install ruby 2.6
RUN curl https://cache.ruby-lang.org/pub/ruby/2.6/ruby-2.6.0.tar.gz -o ruby-2.6.0.tar.gz
# RUN xargs -o tar -xzvf < ruby-2.6.0.tar.gz && \
RUN tar -xzvf ruby-2.6.0.tar.gz && \
  cd ruby-2.6.0 && \
  ./configure && \
  make && \
  make install 

# Cleanup downloads
RUN rm -rf ruby-2.6.0 ruby-2.6.0.tar.gz

# Ruby version
RUN echo "ruby 2.6.0" > /etc/ruby_version

# Install cfn_nag
RUN gem install cfn-nag

COPY scripts/* /usr/local/bin/