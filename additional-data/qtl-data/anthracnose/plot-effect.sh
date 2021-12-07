#!/bin/bash

#module load R/3.5.3
#module load plink/1.90b6.16
#module load vcftools/0.1.16-16-g954e607

CWD=$(dirname $0)
CWD=$(cd $CWD; pwd)

pushd IITA-1402/Field2017
vcftools --012 --gzvcf $CWD/../vcf/IITA-1402.AFI.AG30e20.xFAIL.nr.hap.vcf.gz --out IITA-1402.Field2017 2>/dev/null
$CWD/../plot-qtl-gxp.R IITA-1402.Field2017 Chr5:22308637 IITA-1402.Field2017
$CWD/../plot-qtl-ld.R IITA-1402.Field2017.012 Chr5:22308637 IITA-1402.Field2017.Chr5_22308637.ld
popd

pushd IITA-1402/Field2018
vcftools --012 --gzvcf $CWD/../vcf/IITA-1402.AFI.AG30e20.xFAIL.nr.hap.vcf.gz --out IITA-1402.Field2018 2>/dev/null
$CWD/../plot-qtl-gxp.R IITA-1402.Field2018 Chr19:8369514 IITA-1402.Field2018
$CWD/../plot-qtl-ld.R IITA-1402.Field2018.012 Chr19:8369514 IITA-1402.Field2018.Chr19_8369514.ld
popd  # Chr19:17769220

pushd IITA-1419/DLAmean
vcftools --012 --gzvcf $CWD/../vcf/IITA-1419.AFI.AG30e20.xFAIL.nr.hap.vcf.gz --out IITA-1419.DLAmean 2>/dev/null
$CWD/../plot-qtl-gxp.R IITA-1419.DLAmean Chr6:61001 IITA-1419.DLAmean
$CWD/../plot-qtl-ld.R IITA-1419.DLAmean.012 Chr6:61001 IITA-1419.DLAmean.Chr6_61001.ld
popd
