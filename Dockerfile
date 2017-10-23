
FROM alpine:latest as builder
ENV S3FS_VERSION=v1.82
RUN apk --update --no-cache add fuse alpine-sdk automake autoconf libxml2-dev fuse-dev curl-dev git openssl-dev
RUN git clone https://github.com/s3fs-fuse/s3fs-fuse.git; \
  cd s3fs-fuse; \
  git checkout tags/${S3FS_VERSION}; \
  ./autogen.sh; \
  ./configure --prefix=/usr; \
  make; \
  make install;

FROM alpine:latest
MAINTAINER sysadmin@kronostechnologies.com
RUN apk --update --no-cache add fuse libxml2-dev libstdc++ curl openssl
COPY --from=builder /usr/bin/s3fs /usr/bin/s3fs
CMD s3fs
