FROM debian:buster-slim as builder
ENV S3FS_VERSION=v1.85

RUN apt-get update ; apt-get install -y git autoconf gawk build-essential libcurl4-openssl-dev libfuse-dev libxml2-dev pkg-config libssl-dev
RUN git clone https://github.com/s3fs-fuse/s3fs-fuse.git ; cd s3fs-fuse ; git checkout tags/${S3FS_VERSION}; ./autogen.sh; ./configure ; make

FROM debian:buster-slim
MAINTAINER na-qc@equisoft.com

RUN apt-get update ; apt-get install -y --no-install-recommends --no-install-suggests procps fuse curl libxml2 ; apt-get clean ; rm -rf /var/lib/apt/lists /var/cache/debconf/*-old /var/log/apt/* /var/log/dpkg.log /var/log/alternatives.log
COPY --from=builder /s3fs-fuse/src/s3fs /usr/bin/s3fs

# Install entrypoint
ADD https://github.com/kronostechnologies/docker-init-entrypoint/releases/download/1.3.3/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Install start/stop scripts
COPY ./entrypoint /k

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD s3fs
