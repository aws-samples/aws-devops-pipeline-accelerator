ARG DEBIAN_VERSION=bullseye-20220801-slim

FROM debian:${DEBIAN_VERSION}

RUN apt-get update &&\
    apt-get upgrade -y &&\
    apt-get install -y curl &&\
    apt-get install -y ca-certificates &&\
    apt-get install -y zip &&\
    apt-get install -y unzip &&\
    apt-get install -y wget

# nonroot user
RUN groupadd --gid 1001 nonroot \
  && useradd --gid nonroot --create-home --uid 1001 nonroot
USER nonroot

RUN curl --version

CMD ["bash"]