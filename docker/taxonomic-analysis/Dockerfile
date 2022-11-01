FROM mambaorg/micromamba:0.27.0

RUN \
   micromamba install -y -n base -c defaults -c bioconda -c conda-forge \
      kaiju=1.9.0 \
      krona=2.8.1 \
   && micromamba clean -a -y