FROM mambaorg/micromamba:0.27.0

RUN \
   micromamba install -y -n base -c defaults -c bioconda -c conda-forge \
      mummer4=4.0.0rc1 \
      megahit=1.2.9 \
      seqtk=1.3 \
      amos \
      bwa-mem2=2.2.1 \
      cd-hit=4.8.1 \
   && micromamba clean -a -y

# RUN micromamba update amos
COPY minimus2 /opt/conda/bin/minimus2


