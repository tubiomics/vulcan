FROM mambaorg/micromamba:0.27.0

RUN \
   micromamba install -y -n base -c defaults -c bioconda -c conda-forge -c auto \
      fastani=1.33 \
      vamb=3.0.2 \
      samtools=1.16.1 \
      subread=2.0.1 \
      hmmer=3.1b2 \
      drep=3.4.0 \
      coverm=0.6.1 \
   && micromamba clean -a -y

RUN /opt/conda/bin/python -m pip install Binsanity

COPY Binsanity-profile /opt/conda/bin/Binsanity-profile
