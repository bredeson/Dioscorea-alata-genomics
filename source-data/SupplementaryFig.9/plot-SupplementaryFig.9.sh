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

for panel in a b c d e; do
    bash SupplementaryFig.9${panel}/plot-SupplementaryFig.9${panel}.sh;
done

Rscript SupplementaryFig.9f/plot-SupplementaryFig.9f.R
