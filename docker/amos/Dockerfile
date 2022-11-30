FROM public.ecr.aws/ubuntu/ubuntu:20.04


ARG DEBIAN_FRONTEND=noninteractive
ARG VERSION=3.1.0--py36pl5.22.0_3

RUN apt-get update && apt-get -y install wget

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-4.3.11-Linux-x86_64.sh
ENV CONDA_DIR=/usr/local/miniconda
RUN bash Miniconda3-4.3.11-Linux-x86_64.sh -b -p ${CONDA_DIR}
ENV PATH=$CONDA_DIR/bin:$PATH

RUN conda config --add channels defaults && \
    conda config --add channels bioconda && \
    conda config --add channels conda-forge

RUN conda install amos && conda update amos

# install newer version of mummer
RUN apt-get -y update && \
    apt-get -y install \
      build-essential \
      gcc && \
    apt-get clean

RUN wget https://github.com/mummer4/mummer/releases/download/v4.0.0rc1/mummer-4.0.0rc1.tar.gz && \
    tar -xzf mummer-4.0.0rc1.tar.gz && \
    cd mummer-4.0.0rc1 && \
    ./configure --prefix=/mummer  && \
    make && \
    make install

RUN  rm -rf mummer-4.0.0rc1.tar.gz && rm -rf mummer-4.0.0rc1

# Copy the updated minimus2 script with the new threading options
COPY minimus2 /usr/local/miniconda/bin/minimus2