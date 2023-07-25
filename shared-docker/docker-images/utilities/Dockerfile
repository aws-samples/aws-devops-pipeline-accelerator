ARG DPA_BASE_IMAGE_VERSION=latest
FROM 316172404479.dkr.ecr.us-east-1.amazonaws.com/dpa-base:${DPA_BASE_IMAGE_VERSION}

USER root

COPY scripts/* /usr/local/bin/

USER nonroot

CMD ["bash"]
