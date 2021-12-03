#!/bin/bash

# Assumes a correctly-installed distro of Anaconda/Miniconda and the
# shell has been properly initialized with `conda init bash`

conda create \
      --yes \
      --channel conda-forge \
      --channel bioconda \
      --name r \
      r-base=3.5.3


bash ./Fig.2a/plot-Fig.2a.sh


conda activate r
bash Fig.2b/plot-Fig.2b.sh  # calls an Rscript

Rscript Fig.2c/plot-Fig.2c.R
conda deactivate

bash ./Fig.2d/plot-Fig.2d.sh

