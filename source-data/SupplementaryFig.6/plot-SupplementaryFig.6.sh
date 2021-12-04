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

Rscript ./plot-SupplementaryFig.6.panel.R \
	SupplementaryFig.6.lg.map \
	SupplementaryFig.6.chrom.sizes \
	SupplementaryFig.6.pdf

