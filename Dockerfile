FROM alpine:3.8 as builder
ENV S3FS_VERSION=v1.84
RUN apk --update --no-cache add fuse alpine-sdk automake autoconf libxml2-dev fuse-dev curl-dev git libressl-dev
RUN git clone https://github.com/s3fs-fuse/s3fs-fuse.git; \
  cd s3fs-fuse; \
  git checkout tags/${S3FS_VERSION}; \
  ./autogen.sh; \
  ./configure --prefix=/usr; \
  make; \
  make test;  \
  make install;

FROM alpine:3.8
MAINTAINER sysadmin@kronostechnologies.com
RUN apk --update --no-cache add fuse libxml2-dev libstdc++ curl libressl bash
COPY --from=builder /usr/bin/s3fs /usr/bin/s3fs

# Install entrypoint
ADD https://github.com/kronostechnologies/docker-init-entrypoint/releases/download/1.3.0/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Install start/stop scripts
COPY ./entrypoint /k

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD s3fs

