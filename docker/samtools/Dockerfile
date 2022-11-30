FROM public.ecr.aws/ubuntu/ubuntu:20.04 AS build

ARG VERSION=1.9


# System and library dependencies
RUN apt-get -y update && \
    apt-get -y install \
      autoconf \
      automake \
      make \
      gcc \
      perl \
      zlib1g-dev \
      libbz2-dev \
      liblzma-dev \
      libcurl4-gnutls-dev \
      libssl-dev \
      libncurses5-dev \
      wget && \
    apt-get clean

# Application installation
RUN wget -O /samtools-${VERSION}.tar.bz2 \
  https://github.com/samtools/samtools/releases/download/${VERSION}/samtools-${VERSION}.tar.bz2 && \
  tar xvjf /samtools-${VERSION}.tar.bz2 && rm /samtools-${VERSION}.tar.bz2

WORKDIR /samtools-${VERSION}
RUN ./configure && make

FROM public.ecr.aws/ubuntu/ubuntu:20.04 AS final
COPY --from=build /samtools-*/samtools /usr/local/bin

RUN apt-get -y update && \
    apt-get -y install \
      libcurl3-gnutls && \
    apt-get clean

# ENTRYPOINT ["samtools"]
