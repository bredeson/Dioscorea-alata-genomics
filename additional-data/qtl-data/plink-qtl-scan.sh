#!/bin/bash

if [[ $# -ne 2 ]]; then
    printf "Usage: %s <in.prefix> <M.perms>\n" $(basename $0) >>/dev/fd/2
    exit 1;
fi

# About PLINK Quantitative trait association testing (--assoc):
#   http://zzz.bwh.harvard.edu/plink/anal.shtml#qt
#
# About PLINK max(T) permutation (--mperm-save):
#   http://zzz.bwh.harvard.edu/plink/perm.shtml#mperm
#
# About PLINK's other multiple testing adjustments (--adjust):
#   http://zzz.bwh.harvard.edu/plink/anal.shtml#adjust


pop=$1
P=$2
plink \
    --bfile $pop \
    --allow-no-sex \
    --assoc mperm=$P qt-means \
    --mperm-save \
    --pfilter 1 \
    --threads 1 \
    --out $pop


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
