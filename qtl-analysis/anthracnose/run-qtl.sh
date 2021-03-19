#!/bin/bash

#module load R/3.5.3
#module load plink/1.90b6.16

base=$(dirname $0)

grep -v '^#' $base/../pop.anthracnose.txt | while read pop pheno; do

    mkdir -p $pop/$pheno;

    printf "[%s] Processing %s, %s\n" $(basename $0) $pop $pheno >>/dev/fd/2
    printf "[%s]   Converting VCF to binary PED\n" $(basename $0) >>/dev/fd/2
    $base/../vcf-to-plink.sh \
    	$base/../vcf/$pop.AFI.AG30e20.xFAIL.nr.vcf.gz \
    	$base/../fam/$pop.$pheno.fam \
    	$base/../map/$pop.nr.map \
    	$pop/$pheno/$pop.$pheno \
    &>$pop/$pheno/$pop.$pheno.vcf-to-plink.log;

    n=$(awk 'BEGIN{n=0} {if (/variants and [0-9]+ people pass filters and QC.$/){n=$1}} END{print n}' $pop/$pheno/$pop.$pheno.log);

    printf "[%s]   Performing association test\n" $(basename $0) >>/dev/fd/2
    $base/../plink-qtl-scan.sh \
    	$pop/$pheno/$pop.$pheno 1000000 \
    &>$pop/$pheno/$pop.$pheno.plink-qtl-scan.log;

    printf "[%s]   Plotting association results\n" $(basename $0) >>/dev/fd/2
    $base/../polot-qtl-scan.R \
	$pop/$pheno/$pop.$pheno \
	$base/../Dalata-v2.chrom.sizes \
	0.05 \
    &>$pop/$pheno/$pop.$pheno.plot-qtl-scan.log;
done
