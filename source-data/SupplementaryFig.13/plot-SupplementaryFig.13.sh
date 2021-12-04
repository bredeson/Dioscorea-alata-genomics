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


# Panels a - c: TDa1419 Oxy30Mins
plink \
    --bfile SupplementaryFig.13.1 \
    --allow-no-sex \
    --assoc mperm=1000000 \
    --pfilter 1 \
    --threads 1 \
    --out SupplementaryFig.13a/SupplementaryFig.13a

Rscript plot-SupplementaryFig.13.panel1.sh SupplementaryFig.13a/SupplementaryFig.13a SupplementaryFig.13.chrom.sizes 0.05 SupplementaryFig.13a

Rscript plot-SupplementaryFig.13.panel2.sh SupplementaryFig.13.1 Chr18:26496992 SupplementaryFig.13b

Rscript plot-SupplementaryFig.13.panel3.sh SupplementaryFig.13c/SupplementaryFig.13c.txt.gz Chr18:26496992 SupplementaryFig.13c


# Panels d - f: TDa1419 Oxy180Mins
plink \
    --bfile SupplementaryFig.13.2 \
    --allow-no-sex \
    --assoc mperm=1000000 \
    --pfilter 1 \
    --threads 1 \
    --out SupplementaryFig.13d/SupplementaryFig.13d

Rscript plot-SupplementaryFig.13.panel1.sh SupplementaryFig.13d/SupplementaryFig.13d SupplementaryFig.13.chrom.sizes 0.05 SupplementaryFig.13d

Rscript plot-SupplementaryFig.13.panel2.sh SupplementaryFig.13.2 Chr18:26496992 SupplementaryFig.13e

Rscript plot-SupplementaryFig.13.panel3.sh SupplementaryFig.13f/SupplementaryFig.13f.txt.gz Chr18:26496992 SupplementaryFig.13f


# Panels g - i: TDa1427 Oxy30Mins
plink \
    --bfile SupplementaryFig.13.3 \
    --allow-no-sex \
    --assoc mperm=1000000 \
    --pfilter 1 \
    --threads 1 \
    --out SupplementaryFig.13g/SupplementaryFig.13g

Rscript plot-SupplementaryFig.13.panel1.sh SupplementaryFig.13g/SupplementaryFig.13g SupplementaryFig.13.chrom.sizes 0.05 SupplementaryFig.13g

Rscript plot-SupplementaryFig.13.panel2.sh SupplementaryFig.13.3 Chr18:24495033 SupplementaryFig.13h

Rscript plot-SupplementaryFig.13.panel3.sh SupplementaryFig.13i/SupplementaryFig.13i.txt.gz Chr18:24495033 SupplementaryFig.13i


# Panels j - l: TDa1419 DryMatter
plink \
    --bfile SupplementaryFig.13.4 \
    --allow-no-sex \
    --assoc mperm=1000000 \
    --pfilter 1 \
    --threads 1 \
    --out SupplementaryFig.13j/SupplementaryFig.13j

Rscript plot-SupplementaryFig.13.panel1.sh SupplementaryFig.13j/SupplementaryFig.13j SupplementaryFig.13.chrom.sizes 0.05 SupplementaryFig.13j

Rscript plot-SupplementaryFig.13.panel2.sh SupplementaryFig.13.4 Chr18:25069928 SupplementaryFig.13k

Rscript plot-SupplementaryFig.13.panel3.sh SupplementaryFig.13l/SupplementaryFig.13l.txt.gz Chr18:25069928 SupplementaryFig.13l


# Panels m - o: TDa1401B TuberSize
plink \
    --bfile SupplementaryFig.13.5 \
    --allow-no-sex \
    --assoc mperm=1000000 \
    --pfilter 1 \
    --threads 1 \
    --out SupplementaryFig.13m/SupplementaryFig.13m

Rscript plot-SupplementaryFig.13.panel1.sh SupplementaryFig.13m/SupplementaryFig.13m SupplementaryFig.13.chrom.sizes 0.05 SupplementaryFig.13m

Rscript plot-SupplementaryFig.13.panel2.sh SupplementaryFig.13.5 Chr12:310852 SupplementaryFig.13n

Rscript plot-SupplementaryFig.13.panel3.sh SupplementaryFig.13o/SupplementaryFig.13o.txt.gz Chr12:310852 SupplementaryFig.13o


# Panels p - r: TDa1512 TuberShape
plink \
    --bfile SupplementaryFig.13.6 \
    --allow-no-sex \
    --assoc mperm=1000000 \
    --pfilter 1 \
    --threads 1 \
    --out SupplementaryFig.13p/SupplementaryFig.13p

Rscript plot-SupplementaryFig.13.panel1.sh SupplementaryFig.13p/SupplementaryFig.13p SupplementaryFig.13.chrom.sizes 0.05 SupplementaryFig.13p

Rscript plot-SupplementaryFig.13.panel2.sh SupplementaryFig.13.6 Chr7:3115608 SupplementaryFig.13q

Rscript plot-SupplementaryFig.13.panel3.sh SupplementaryFig.13r/SupplementaryFig.13r.txt.gz Chr7:3115608 SupplementaryFig.13r

