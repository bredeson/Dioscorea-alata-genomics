#!/bin/bash

# Assumes a correctly-installed distro of Anaconda/Miniconda and the
# shell has been properly initialized with `conda init bash`

# conda create \
#      --yes \
#      --channel conda-forge \
#      --channel bioconda \
#      --name r \
#      r-base=3.5.3

# conda activate r

CWD=$(dirname $0);

Rscript $CWD/../../software/wgs-analysis/bin/plot-allele-balance-scat.R \
	SupplementaryFig.14a/SupplementaryFig.14a.het.txt \
	SupplementaryFig.14a/SupplementaryFig.14a.hom.txt \
	0.001 \
	0.001 \
	500 \
	SupplementaryFig.14a.png

Rscript $CWD/../../software/wgs-analysis/bin/plot-allele-balance-scat.R \
	SupplementaryFig.14b/SupplementaryFig.14b.het.txt \
	SupplementaryFig.14b/SupplementaryFig.14b.hom.txt \
	0.001 \
	0.001 \
	150 \
	SupplementaryFig.14b.png

