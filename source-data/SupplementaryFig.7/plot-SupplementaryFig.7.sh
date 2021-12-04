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

CWD=$(dirname $0);

Rscript $CWD/../../software/artisanal/src/call-compartments.R \
	SupplementaryFig.7a/SupplementaryFig.7a.bed \
	SupplementaryFig.7a/SupplementaryFig.7a.%s.txt.gz \
	1.0 \
	SupplementaryFig.7a

Rscript $CWD/../../software/artisanal/src/call-compartments.R \
	SupplementaryFig.7b/SupplementaryFig.7b.bed \
	SupplementaryFig.7b/SupplementaryFig.7b.%s.txt.gz \
	1.0 \
	SupplementaryFig.7b
