FROM mambaorg/micromamba:0.27.0

RUN \
   micromamba install -y -n base -c defaults -c bioconda -c conda-forge -c auto \
      checkm=0.4 \
      concoct=1.1.0 \
   && micromamba clean -a -y