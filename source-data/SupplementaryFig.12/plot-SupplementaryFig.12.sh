#!/bin/bash

# Assumes a correctly-installed distro of Anaconda/Miniconda and the
# shell has been properly initialized with `conda init bash`

conda create \
      --yes \
      --channel conda-forge \
      --channel bioconda \
      --name qtl \
      plink=1.90b6.18 \
      r-base=3.5.3

conda activate qtl 

# About PLINK Quantitative trait association testing (--assoc):
#   http://zzz.bwh.harvard.edu/plink/anal.shtml#qt
#
# About PLINK max(T) permutation (--mperm-save):
#   http://zzz.bwh.harvard.edu/plink/perm.shtml#mperm
#
# About PLINK's other multiple testing adjustments (--adjust):
#   http://zzz.bwh.harvard.edu/plink/anal.shtml#adjust


# Panels a - c: TDa1402 Field2018
plink \
    --bfile SupplementaryFig.12.1 \
    --allow-no-sex \
    --assoc mperm=1000000 \
    --pfilter 1 \
    --threads 1 \
    --out SupplementaryFig.12a/SupplementaryFig.12a

Rscript plot-SupplementaryFig.12.panel1.sh SupplementaryFig.12a/SupplementaryFig.12a SupplementaryFig.12.chrom.sizes 0.05 SupplementaryFig.12a

Rscript plot-SupplementaryFig.12.panel2.sh SupplementaryFig.12.1 Chr19:8369514 SupplementaryFig.12b

Rscript plot-SupplementaryFig.12.panel3.sh SupplementaryFig.12c/SupplementaryFig.12c.txt.gz Chr19:8369514 SupplementaryFig.12c


# Panels e - g: TDa1419 DLAmean
plink \
    --bfile SupplementaryFig.12.2 \
    --allow-no-sex \
    --assoc mperm=1000000 \
    --pfilter 1 \
    --threads 1 \
    --out SupplementaryFig.12e/SupplementaryFig.12e

Rscript plot-SupplementaryFig.12.panel1.sh SupplementaryFig.12e/SupplementaryFig.12e SupplementaryFig.12.chrom.sizes 0.05 SupplementaryFig.12e

Rscript plot-SupplementaryFig.12.panel2.sh SupplementaryFig.12.2 Chr6:61001 SupplementaryFig.12f

Rscript plot-SupplementaryFig.12.panel3.sh SupplementaryFig.12g/SupplementaryFig.12g.txt.gz Chr6:61001 SupplementaryFig.12g

