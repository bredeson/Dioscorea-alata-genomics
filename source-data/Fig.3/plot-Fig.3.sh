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


plink \
    --bfile Fig.3 \
    --allow-no-sex \
    --assoc mperm=1000000 \
    --pfilter 1 \
    --threads 1 \
    --out Fig.3b/Fig.3b

# Writes:
#  $pop.qassoc
#   CHR      Chromosome number
#   SNP      SNP identifier
#   BP       Physical position (base-pair)
#   NMISS    Number of non-missing genotypes
#   BETA     Regression coefficient
#   SE       Standard error
#   R2       Regression r-squared
#   T        Wald test (based on t-distribtion)
#   P        Wald test asymptotic p-value
#
#  $pop.qassoc.mperm with columns:
#   CHR     Chromosome
#   SNP     SNP ID
#   EMP1    Empirical p-value (pointwise)
#   EMP2    Corrected empirical p-value (max(T) / familywise) 
#
#  $pop.mperm.dump.best with columns:
#   REP     replicate number (0 represents the original data, the remaining rows 1 to R where R is the number of permutations specified)
#   MAX_T   maximum test statistic over all SNPs for that replicate (appears to already be -log10-transformed)

Rscript Fig.3b/plot-Fig.3b.R Fig.3b/Fig.3b Fig.3.chrom.sizes 0.05 Fig.3b

Rscript Fig.3c/plot-Fig.3c.R Fig.3 Chr5:22308637 Fig.3c

Rscript Fig.3d/plot-Fig.3d.R Fig.3d/Fig.3d.txt Chr5:22308637 Fig.3d

