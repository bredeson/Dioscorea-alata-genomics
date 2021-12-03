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


Rscript ./Fig.4c/plot-Fig.4c.R Fig.4c/Fig.4c.roh.conf Fig.4c/Fig.4c.var.conf Fig.4.chrom.sizes Fig.4.chrom.alias Fig.4c.pdf

Rscript ./Fig.4d/plot-Fig.4d.R Fig.4d/Fig.4d.TDa95-00328.conf ./Fig.4.chrom.sizes Fig.4.chrom.alias Fig.4d.1.pdf

Rscript ./Fig.4d/plot-Fig.4d.R Fig.4d/Fig.4d.TDa95-310.conf ./Fig.4.chrom.sizes Fig.4.chrom.alias Fig.4d.2.pdf

