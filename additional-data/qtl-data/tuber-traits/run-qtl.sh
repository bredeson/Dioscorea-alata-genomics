#!/bin/bash

#module load R/3.5.3
#module load plink/1.90b6.16

base=$(basename $0)
CWD=$(dirname $0)
CWD=$(cd $CWD; pwd)

grep -v '^#' $CWD/../pop.tuber-traits.txt | while read pop pheno; do

    mkdir -p $pop/$pheno;

    printf "[%s] Processing %s, %s\n" $base $pop $pheno >>/dev/fd/2
    printf "[%s]   Converting VCF to binary PED\n" $base >>/dev/fd/2
    $CWD/../vcf-to-plink.sh \
    	$CWD/../vcf/$pop.AFI.AG30e20.xFAIL.nr.vcf.gz \
    	$CWD/../fam/$pop.$pheno.fam \
    	$CWD/../map/$pop.nr.map \
    	$pop/$pheno/$pop.$pheno \
    &>$pop/$pheno/$pop.$pheno.vcf-to-plink.log;

    n=$(awk 'BEGIN{n=0} {if (/variants and [0-9]+ people pass filters and QC.$/){n=$1}} END{print n}' $pop/$pheno/$pop.$pheno.log);

    printf "[%s]   Performing association test\n" $base >>/dev/fd/2
    $CWD/../plink-qtl-scan.sh \
    	$pop/$pheno/$pop.$pheno 1000000 \
    &>$pop/$pheno/$pop.$pheno.plink-qtl-scan.log;

    printf "[%s]   Plotting association results\n" $base >>/dev/fd/2
    $CWD/../plot-qtl-scan.R \
	$pop/$pheno/$pop.$pheno \
	$CWD/../Dalata-v2.chrom.sizes \
	0.05 \
	$pop/$pheno/$pop.$pheno \
    &>$pop/$pheno/$pop.$pheno.plot-qtl-scan.log;
done
