FROM adoptopenjdk/openjdk11:jre-11.0.16.1_1-ubuntu

ARG DEBIAN_FRONTEND=noninteractive
ARG VERSION=38.92

RUN apt-get update && apt-get install -y --no-install-recommends wget

RUN wget --no-check-certificate https://sourceforge.net/projects/bbmap/files/BBMap_$VERSION.tar.gz && \
  tar -xzf BBMap_$VERSION.tar.gz && \
  rm -rf BBMap_$VERSION.tar.gz

# add bbtools to path
ENV PATH="${PATH}:/bbmap"
ENV LC_ALL=C