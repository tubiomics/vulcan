FROM mambaorg/micromamba:0.27.0

RUN \
   micromamba install -y -n base -c defaults -c bioconda -c conda-forge \
      fastp=0.23.2 \
      seqkit=2.3.1 \
   && micromamba clean -a -y