#!/bin/bash

# Assumes a correctly-installed distro of Anaconda/Miniconda and the
# shell has been properly initialized with `conda init bash`

conda create \
     --yes \
     --channel conda-forge \
     --channel bioconda \
     --name r \
     r-base=3.5.3 \
     r-vegan \
     r-gplots

conda activate r

Rscript ./plot-SupplementaryFig.5.panel.R \
    && mv rabl/Chr2-Chr4.MQ30.obs.rabl.pdf SupplementaryFig.5a.pdf \
    && mv rabl/Chr2-Chr5.MQ30.obs.rabl.pdf SupplementaryFig.5b.pdf \
    && rm -r rabl

