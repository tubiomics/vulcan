FROM mambaorg/micromamba:0.27.0

# Install base R
RUN \
   micromamba install -y -n base -c defaults -c conda-forge -c r \
      r-base=4.2.2 \
   && micromamba clean -a -y

# Install R packages
RUN \
   micromamba install -y -n base -c defaults -c conda-forge -c r -c bioconda \
      r-abind=1.4_5 \
      r-ade4=1.7_20 \
      r-agricolae=1.3_5 \
      # bioconductor-aldex2=1.30.0 \
      r-algdesign=1.2.1 \
      # bioconductor-annotate=1.76.0 \ 
   && micromamba clean -a -y
