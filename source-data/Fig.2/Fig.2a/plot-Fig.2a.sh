#!/bin/bash

# Assumes a correctly-installed distro of Anaconda/Miniconda and the
# shell has been properly initialized with `conda init bash`

conda create \
      --yes \
      --channel conda-forge \
      --channel bioconda \
      --name jcvi \
      python=3.7.6 \
      jcvi=1.0.14

conda activate jcvi

python -m jcvi.graphics.karyotype \
      --format pdf \
      --font Arial \
      --figsize 14x7 \
      Fig.2a/Fig.2a.seqids \
      Fig.2a/Fig.2a.layout

mv karyotype.pdf Fig.2a.pdf