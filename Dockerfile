FROM mambaorg/micromamba:0.27.0

COPY --chown=$MAMBA_USER:$MAMBA_USER environment.yaml /tmp/environment.yaml
RUN micromamba install -y -n base -f /tmp/environment.yaml && \
    micromamba clean --all --yes
