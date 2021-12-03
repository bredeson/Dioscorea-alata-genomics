#!/bin/bash

# Assumes a correctly-installed distro of Anaconda/Miniconda and the
# shell has been properly initialized with `conda init bash`

conda create \
     --yes \
     --channel conda-forge \
     --channel bioconda \
     --name r \
     r-base=3.5.3

conda activate r

Rscript ./Fig.1b/plot-Fig.1b.R Fig.1b/Fig.1b.txt Fig.1b

Rscript ./Fig.1c/plot-Fig.1c.R

